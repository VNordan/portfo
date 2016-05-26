class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :out_id, limit: 8
      t.string  :task_name
      t.integer :task_type
      t.date    :task_plan
      t.date    :task_fact
      t.integer :group_type
      t.integer :object_id, limit: 8

      t.timestamps null: false
    end
  end
end
