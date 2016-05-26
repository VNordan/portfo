class DocumentType < ActiveRecord::Base
  has_many :documents, class_name: 'Document', primary_key: 'id', foreign_key: 'doc_type_id'


  def self.fake_documents_types
    [{name:'ГПЗУ', id: 1}, {name:'МГЭ', id: 2},{name:'Разрешение на стр.', id: 3} ]
  end

  def self.fake_documents_type_cats
    [{id: 1, type_id: 1, category_id: 2 }, {id: 2, type_id: 2, category_id: 2 },{id: 3, type_id: 3, category_id: 2 } ]
  end


end
