class CreateOtrasls < ActiveRecord::Migration
  def change
    create_table :otrasls do |t|

      t.string :otrasl_name

      t.timestamps null: false
    end
  end
end
