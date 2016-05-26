class AddColumnToTasks < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.integer :task_type_id, limit: 8
    end
  end
end
