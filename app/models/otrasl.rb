class Otrasl < ActiveRecord::Base
  has_many :construction_object, foreign_key: 'otrasl_id', primary_key: 'id'
end
