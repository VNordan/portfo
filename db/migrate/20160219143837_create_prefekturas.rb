class CreatePrefekturas < ActiveRecord::Migration
  def change
     create_table :prefekturas do |t|
      t.string :prefektura_name

      t.timestamps null: false
    end
  end
end
