class ConstructionObject < ActiveRecord::Base
  belongs_to :obj, foreign_key: 'code_ds', primary_key: 'Code_DS'
  has_many :documents, primary_key: 'id', foreign_key: 'construction_object_id'
  has_many :tasks, primary_key: 'id', foreign_key: 'object_id'
  has_many :tradess, primary_key: 'id', foreign_key: 'object_id'
  belongs_to :otrasl, foreign_key: 'otrasl_id'
  belongs_to :prefektura, foreign_key: 'prefektura_id'
  belongs_to :podotrasl_obj, class_name:'Podotrasl', foreign_key: 'podotrasl_id'

  delegate :getYearCorrect, to: :obj, prefix: true, allow_nil: true
  delegate :year_plan, to: :obj, prefix: true, allow_nil: true
  delegate :projector, to: :obj, prefix: true, allow_nil: true
  delegate :techinikal_customer, to: :obj, prefix: true, allow_nil: true
  delegate :general_builder, to: :obj, prefix: true, allow_nil: true

  delegate :evacuation_status, to: :obj, prefix: true, allow_nil: true
  delegate :evacuation_date_plan, to: :obj, prefix: true, allow_nil: true
  delegate :evacuation_date, to: :obj, prefix: true, allow_nil: true
  delegate :demolition_status, to: :obj, prefix: true, allow_nil: true
  delegate :demolition_date_plan, to: :obj, prefix: true, allow_nil: true
  delegate :demolition_date, to: :obj, prefix: true, allow_nil: true

  scope :only_active, -> { where(is_active: true).where('planning_comissioning_date > ?', '2010-01-01') }
  scope :only_active_with_sql, -> { where(is_active: true).where('planning_comissioning_date > ?', '2010-01-01') .includes(:obj) }



  def self.all_objects_json
    objs = []
    ConstructionObject.only_active_with_sql.each do |o|
      objs.push({
                    :id => o.id,
                    :region_id => o.prefektura_id,
                    :type_id => o.obj.get_object_type_id_from_list,
                    :address => o.object_name,
                    :plan_id => (o.seria=='ИНД') ? 1 : 2,
                    :is_archive =>  o.obj.is_archive ? 1 : 0 ,
                    :date => o.planning_comissioning_date.nil? ? nil : o.planning_comissioning_date.to_time.to_i,
                    :latitude => o.latitude,
                    :longitude => o.longitude,
                    :power => o.living_space||o.total_places,
                    :power_unit_name => o.total_places.blank?||o.total_places==0 ? "м2": "мест",
                    :without_date => 0,
                    :video_url => "http://213.85.34.118:50080/webcam.mp4"
                })
    end
    objs
  end

  def self.objects_types_hierarchy
    res = []
    ConstructionObject.only_active.select('otrasl_id, otrasl_name').
        group('otrasl_id, otrasl_name').inject(res) {|array, type| array << {id:type.otrasl_id*10000,
                                                                             parent_id: 0,
                                                                             name:type.otrasl_name,
                                                                             is_living: ((['Жилище'].include?(type.otrasl_name)) ? true : false),
                                                                             is_social: ((['Спорт','Здравоохранение','Образование','Социальная сфера'].include?(type.otrasl_name)) ? true : false )}}
    ConstructionObject.only_active.select('podotrasl, otrasl_id, podotrasl_id').
        group('podotrasl, otrasl_id, podotrasl_id').inject(res) {|array, type| array << {id:type.podotrasl_id,
                                                                                         parent_id: type.otrasl_id*10000,
                                                                                         name:type.podotrasl,
                                                                                         is_living: false,
                                                                                         is_social: false}}
    res
  end

  def self.land_passports
    gpzus = []
    gpzu_task_id = TaskType.find_by("task_type like '%ГПЗУ%'").id
    Task.where(task_type_id: gpzu_task_id).each do |task|
      gpzus.push ({id: task.id, object_id: task.object_id,
                   expected_receive_date:task.task_plan.nil? ? nil : task.task_plan.to_time.to_i,
                   real_receive_date: task.task_fact.nil? ? nil : task.task_fact.to_time.to_i
                 })
    end
    gpzus
  end

  def self.expertises
    expertises = []
    mge_task_id = TaskType.find_by("task_type like '%МГЭ%'").id
    Task.where(task_type_id: mge_task_id).each do |task|
      expertises.push ({id: task.id, object_id: task.object_id,
                        expected_receive_date:task.task_plan.nil? ? nil : task.task_plan.to_time.to_i,
                        real_receive_date: task.task_fact.nil? ? nil : task.task_fact.to_time.to_i
                      })
    end
    expertises
  end

  def self.demolitions
    demolitions = []
    ConstructionObject.only_active_with_sql.each do |c_obj|
      demolitions.push({ id: c_obj.id, object_id: c_obj.id,
                         expected_receive_date: c_obj.obj.evacuation_date_plan.nil? ? 0 : c_obj.obj.evacuation_date_plan.to_time.to_i,
                         real_receive_date: c_obj.obj.evacuation_date.nil? ? 0 : c_obj.obj.evacuation_date.to_time.to_i
      })
    end
    demolitions
  end

  def self.permits
    permits = []
    ConstructionObject.only_active_with_sql.includes(obj: [:object_document]).each do |c_obj|
      permits.push({ id: c_obj.id, object_id: c_obj.id,
                         expected_receive_date: c_obj.obj.object_document.razrezh_build_plan.nil? ? nil : c_obj.obj.object_document.razrezh_build_plan.to_time.to_i,
                         real_receive_date: c_obj.obj.object_document.razrezh_build_fact.nil? ? nil : c_obj.obj.object_document.razrezh_build_fact.to_time.to_i
                       })
    end
    permits
  end

  def self.documents_statuses
    documents = []
    Document.all.each do |doc|
      documents << { id: doc.id,
                     object_id: doc.construction_object_id,
                     type_id: doc.doc_type_id*10,
                     expected_receive_date: doc.date_term_timestamp,
                     real_receive_date: doc.doc_date_timestamp}
    end
    gpzu_task_id = TaskType.find_by("task_type like '%ГПЗУ%'").id
    Task.where(task_type_id: gpzu_task_id).each do |task|
      documents.push ({id: task.id, object_id: task.object_id, type_id:1,
                   expected_receive_date:task.task_plan.nil? ? nil : task.task_plan.to_time.to_i,
                   real_receive_date: task.task_fact.nil? ? nil : task.task_fact.to_time.to_i
                 })
    end
    mge_task_id = TaskType.find_by("task_type like '%МГЭ%'").id
    Task.where(task_type_id: mge_task_id).each do |task|
      documents.push ({id: task.id, object_id: task.object_id, type_id:2,
                        expected_receive_date:task.task_plan.nil? ? nil : task.task_plan.to_time.to_i,
                        real_receive_date: task.task_fact.nil? ? nil : task.task_fact.to_time.to_i
                      })
    end

    permit_task_id = TaskType.find_by("task_type like '%Разрешение на строительство%'").id
    Task.where(task_type_id: permit_task_id).each do |task|
      documents.push ({id: task.id, object_id: task.object_id, type_id:3,
                     expected_receive_date:task.task_plan.nil? ? nil : task.task_plan.to_time.to_i,
                     real_receive_date: task.task_fact.nil? ? nil : task.task_fact.to_time.to_i
                   })
    end
    documents
  end
end