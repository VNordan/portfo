class AddIsActiveToConstructionObjects < ActiveRecord::Migration
  def change
    change_table :construction_objects do |t|
      t.boolean  :is_active
    end
  end
end
