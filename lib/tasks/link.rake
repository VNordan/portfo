namespace :link do
  desc 'Tasks for linking data between tables'
  @bulk_size = 1000
  @task_name = 'link'

  task all: :environment do
    Rake::Task["link:documents"].invoke
  end

  task documents: :environment do
    for t in 0..1+Document.count/@bulk_size
      puts "   ->linking documents #{t*@bulk_size} - #{(t+1)*@bulk_size}"
      Document.transaction do
        Document.limit(@bulk_size).offset(t*@bulk_size).order(:id).each do |d|
          d.set_links
        end
      end
    end
  end

end