class CreateImportedPhotos < ActiveRecord::Migration
  def change
    create_table :imported_photos do |t|
      t.integer :photo_out_id, index: true
      t.integer :obj_id
      t.date    :photo_date
      t.string  :url

    end
  end
end
