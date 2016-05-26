class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|

      t.string :company_title, limit: 400
      t.integer :out_id, limit: 8
      t.string  :inn, limit: 25
      t.string :short_title, limit: 100


      t.timestamps null: false
    end
  end
end
