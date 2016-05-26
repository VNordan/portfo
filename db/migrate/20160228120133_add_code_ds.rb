class AddCodeDs < ActiveRecord::Migration
  def change

    change_table :construction_objects do |t|
      t.string  :code_ds, limit: 100
    end
  end
end
