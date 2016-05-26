class Task < ActiveRecord::Base
  belongs_to :task_type,  foreign_key: 'task_type_id'
  belongs_to :construction_object,  foreign_key: 'object_id'
end
