class CreateEngeneeringNetworkLinks < ActiveRecord::Migration
  def change
    create_table :engeneering_network_links do |t|

      t.integer :object_out_id, limit: 8
      t.integer :network_id
      t.float   :percentage

      t.timestamps null: false
    end
  end
end
