class AddColumnsToConstructionObject < ActiveRecord::Migration
  def change
    change_table :construction_objects do |t|
      t.integer :podotrasl_id
      t.integer :prefektura_id
    end
  end
end
