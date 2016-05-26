class AddOtraslToObject < ActiveRecord::Migration
  def change
    change_table :construction_objects do |t|
      t.string  :otrasl_name
      t.integer :otrasl_id
    end
  end
end
