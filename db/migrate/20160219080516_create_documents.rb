class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|

      t.integer :out_id, limit: 8
      t.string  :doc_type
      t.integer :doc_type_id, limit: 8
      t.string  :doc_number
      t.date    :doc_date
      t.string  :doc_status
      t.integer :doc_status_id, limit: 8
      t.date    :doc_term
      t.integer :construction_object_out_id, limit: 8
      t.integer :construction_object_id, limit: 8
      
      t.timestamps null: false
    end
  end
end
