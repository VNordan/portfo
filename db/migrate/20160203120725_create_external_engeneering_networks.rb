class CreateExternalEngeneeringNetworks < ActiveRecord::Migration
  def change
    create_table :external_engeneering_networks do |t|
      t.string  :network_name
      t.string  :network_alias

      t.timestamps null: false
    end
  end
end
