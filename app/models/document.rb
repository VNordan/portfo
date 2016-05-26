class Document < ActiveRecord::Base
  belongs_to :document_type, class_name: 'DocumentType', foreign_key: 'doc_type_id'
  belongs_to :construction_object, foreign_key: 'construction_object_id'

  def set_links
    self.construction_object = ConstructionObject.find_by(out_id: construction_object_out_id)
    self.save
  end

  def date_term_timestamp
    doc_term.nil? ? nil : (doc_term.to_time+3.hours).to_i
  end

  def doc_date_timestamp
    doc_date.nil? ? nil : (doc_date.to_time+3.hours).to_i
  end

end

