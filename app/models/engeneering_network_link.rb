class EngeneeringNetworkLink < ActiveRecord::Base
  belongs_to :construction_object, foreign_key: 'object_out_id', primary_key:'out_id'
end
