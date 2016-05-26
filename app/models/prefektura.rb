class Prefektura < ActiveRecord::Base
  has_many :construction_object, foreign_key: 'prefektura_id', primary_key: 'id'
end
