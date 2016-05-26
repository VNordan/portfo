class Podotrasl < ActiveRecord::Base
  has_many :construction_object, foreign_key: 'podotrasl_id', primary_key: 'id'
end
