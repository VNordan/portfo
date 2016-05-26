namespace :auth do
    
    desc "Регенерация пользовательского токена"

    task :regenerate_token => :environment do
        u = User.find_by email: 'holm-van@narod.ru' # здесь необходимо указать е-майл нужного пользователя
        u.authentication_token = ""
        u.save!
    end

end