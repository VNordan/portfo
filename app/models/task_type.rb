class TaskType < ActiveRecord::Base
  has_many :tasks, primary_key: 'id', foreign_key: 'task_type_id'
end
