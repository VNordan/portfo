class ImportedPhoto < ActiveRecord::Base
  belongs_to :obj

  def small_photo_url
    return "http://213.85.34.118:50080" + "/pictures/#{self.obj_id}/#{self.photo_out_id}_s.jpg"
  end
  def big_photo_url
    return "http://213.85.34.118:50080" + "/pictures/#{self.obj_id}/#{self.photo_out_id}_b.jpg"
  end


  def self.objects_photos
    values = []
    ConstructionObject.includes(:obj).each do |object|
      next if object.obj.nil?
      d = ImportedPhoto.select('MAX(photo_date::date) as max_date').group('obj_id').where("obj_id = ?", object.obj.id).take
      last_date = d.max_date if d.present?
      values.concat ImportedPhoto.photos_by_object_and_date object.obj.id, last_date if last_date.present?
    end
    values
  end

  def self.photos_by_object_and_date obj_id, date
    values = []
    ImportedPhoto.includes(obj: [:construction_object]).where('photo_date >= ?', date).where(obj_id: obj_id).each do |p|
      next if p.obj.nil?
      next if p.obj.construction_object.nil?
      values << {
          object_id: p.obj.construction_object.id,
          preview_url: p.small_photo_url,
          full_image_url: p.big_photo_url,
          date: p.photo_date.to_time.to_i
      }
    end
    values
  end

  def self.import
    ObjectPhoto.find_in_batches(batch_size: 1000).with_index do |group, batch|
      puts "  Processing photo  - ##{batch*1000}"
      ImportedPhoto.transaction do
        group.each do |photo|
          imported_photo = ImportedPhoto.find_or_initialize_by(photo_out_id: photo.id)
          imported_photo.obj_id = photo.object_id
          imported_photo.photo_date = photo.photo_date
          imported_photo.url = photo.url
          imported_photo.save
        end

      end
    end
  end
end
