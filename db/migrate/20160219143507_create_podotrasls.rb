class CreatePodotrasls < ActiveRecord::Migration
  def change
    create_table :podotrasls do |t|
      t.string :podotrasl_name

      t.timestamps null: false
    end
  end
end
