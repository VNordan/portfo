class Obj < ActiveRecord::Base
  Obj.establish_connection :mssqlObjects

  self.table_name = 'vw_ObjectForMobileInfo_NEW'
  self.primary_key = 'ObjectId'

  has_one :object_finance, foreign_key: 'ObjectId'
  has_one :object_document, foreign_key: 'ObjectId'
  has_one :object_prepare, foreign_key: 'ObjectId'
  # has_one :organization, foreign_key: 'OrganizationGenBuilder', primary_key: 'OrganizationName'
  has_many :object_finance_by_work_types, foreign_key: 'ObjectID'
  has_many :object_tenders, foreign_key: 'ObjectID'
  has_many :visit_infos, foreign_key: 'ObjectId'
  has_many :object_photos, foreign_key: 'ObjId'
  has_many :object_bank_garantee, foreign_key: 'ObjectId'

  alias_attribute 'id','ObjectId' #
  #АДрес
  alias_attribute 'region' , 'ObjectRegionName'
  alias_attribute 'seria' , 'ObjectSerialName'
  alias_attribute 'adress','ObjectAdress' #
  alias_attribute 'name','ObjectName' #
  alias_attribute 'lat', 'ObjectShirota'
  alias_attribute 'lng', 'ObjectDolgota'

  alias_attribute 'manager','ObjectManager' #
  # лица и учатсники
  alias_attribute 'general_builder', 'OrganizationGenBuilder' #
  alias_attribute 'techinikal_customer', 'OrganizationTehZakaz' #
  alias_attribute 'projector','OrganizationProjector' #проектировщик
  alias_attribute 'build_control','StroiControl' #строй контроль

  alias_attribute 'appointment','ObjectAppointmentName' # Назначение
  alias_attribute 'indastry','ObjectAppointmentType' # Отрасль
  alias_attribute 'budget','ObjectFinanceBudget' #
  alias_attribute 'summ_PPS', 'SumPSS'

  alias_attribute 'is_archive','ObjectArchve' #

  alias_attribute 'data_enter_kontract', 'DataRazreshVvod' # срок ввода по контракту
  alias_attribute 'year_plan','ObjectEnterYearPlan' # факт
  alias_attribute 'year_correct','ObjectEnterYearCorrect' # по плану
  #alias_attribute 'year_DS','ObjectEnterYear' #
  #alias_attribute 'date_of_enter','ObjectDataEnter' #

  alias_attribute 'power','Power' #
  alias_attribute 'power_measure','PowerEdIzm' #

  alias_attribute 'status_name','ObjectStatusName' #

  alias_attribute 'floors','ObjectAmountFloor' #

  alias_attribute 'photo_path','ObjectPhotoPath' #

  alias_attribute 'evacuation_status', 'EvacuationStatus'
  alias_attribute 'evacuation_date', 'ObjectEvacuationDataFact'
  alias_attribute 'evacuation_date_plan', 'ObjectEvacuationDataPlan'

  alias_attribute 'demolition_status', 'DemolitionStatus'
  alias_attribute 'demolition_date', 'ObjectDemolitionDataFact'
  alias_attribute 'demolition_date_plan', 'ObjectDemolitionDataPlan'

  #квартирография
  alias_attribute 'rooms_square', 'SRooms'
  alias_attribute 'count_1k', 'Q1Rooms'
  alias_attribute 'count_2k', 'Q2Rooms'
  alias_attribute 'count_3k', 'Q3Rooms'
  alias_attribute 'count_4k', 'Q4Rooms'

  #Движение по графику производства работ
  alias_attribute 'SMR_external_network', 'SMR_ExternalNetwork'
  alias_attribute 'SMR_external_network_delay', 'SMR_LooserExtern'
  alias_attribute 'SMR_constructive', 'SMR_Constructive'
  alias_attribute 'SMR_constructive_delay', 'SMR_LooserConstr'
  alias_attribute 'SMR_internal', 'SMR_InternalSystems'
  alias_attribute 'SMR_internal_delay', 'SMR_LooserIntern'

  alias_attribute 'code_ds', 'Code_DS'

  belongs_to :construction_object, foreign_key: 'Code_DS', primary_key: 'code_ds'


  @@objects_types_hierarchy
  @@objects_regions

  def address
    adress
  end

  def in_aip?
    (self.year_correct||'').start_with?('20') ? 0 : 1
  end

  def self.get_years_enters_plan
    return Obj.group('ObjectEnterYearPlan').order(:year_plan).count(:id)
  end

  def self.get_years_enters_fact
    return Obj.group('YEAR(ObjectEnterYearCorrect)').order('YEAR(ObjectEnterYearCorrect)').count(:id)
  end


  def getYearCorrect
    return self.year_correct||'----'
    if self.year_correct == nil
      return '----';
    end
    parts = self.year_correct.to_s.split
    if parts==nil
    end
    return Date.parse(parts[0]).year

  end

  def complete_date
    self.year_correct.nil? ? nil : Date.parse("#{self.year_correct}-01-01").to_time.to_i
  end

  def getVisitsInfo
    return VisitInfo.where(object_id: self.id).order(:object_id, :sort1, :sort2)
  end

  def getGPZUStatus
    return self.object_document.getGPZUStatus
  end

  def getMGEStatus
    return self.object_document.getMGEStatus
  end

  def getRazreshStatus
    return self.object_document.getRazreshStatus
  end

  def getBankGarantStatus
    status = 'Погашена'
    self.object_finance_by_work_types.each do |wtype|
      if wtype.bank_garanty_status != status
        return 'Просрочено'
      end
    end
    return status;
  end

  def getDestroyStatus
    if (self.demolition_date_plan==nil && self.demolition_date==nil)
      return 'Не требуется'
    end
    if (self.demolition_date!=nil)
      return 'Выпоненен'
    end
    if(self.demolition_date_plan!=nil && self.demolition_date==nil && Date.parse(self.demolition_date_plan.to_s)>Date.current)
      return 'Требуется'
    end
    if(self.demolition_date_plan!=nil && self.demolition_date==nil && Date.parse(self.demolition_date_plan.to_s)<Date.current)
      return 'Просрочено'
    end
  end

  def self.getAllDistricts
    return Obj.where(is_archive: 0).select('region').distinct
  end

  def organization
    return Organization.find_by(name: self.general_builder)
  end

  def tenders
    return ObjectTender.where(object_id: self.id)
  end
  # todo
  # сделать выбор правильного года
  def self.getAllEnterYears
    res = Array.new
    #Obj.where(is_archive: 0).select('ObjectEnterYearCorrect').each do |o|
    #  if (!res.include?(o.getYearCorrect.to_s))
    #    res.push(o.getYearCorrect.to_s)
    #  end
    #end

    Obj.where(is_archive: 0).select('ObjectEnterYearCorrect').distinct.each do |o|
      res.push(o.year_correct||'----')
    end
    return res
  end

  def self.notArchive
    return Obj.where(is_archive: 0).includes(:object_finance).includes(:object_document).includes(:object_finance_by_work_types)
  end

  def get_object_finance_by_type (type)
    if (type==1)
      return ObjectFinanceByWorkType.where(work_type: 'СМР', object_id: self.id)
    else
      return ObjectFinanceByWorkType.where.not(work_type: 'СМР').where(object_id: self.id).group('ObjectId')
    end

  end

  def appointment_adaptive
    if (appointment=='Гаражи' || appointment=='Прочие объекты')
      return 'Прочие'
    end
    appointment
  end

  def self.overdueObjects
    return Obj.where('ObjectArchive = 0').includes(:object_document)#.where("DataPlanGPZU < ?", Date.current )
  end

  def self.getAllAppointmentType
    appointments = Obj.select('appointment').distinct
    puts appointments
    return appointments
  end

  def self.objects_types_hierarchy
    @@objects_types_hierarchy = [
      {id:1, parent_id: 0, name:'Жилище', is_living: true, is_social: false},
      {id:2, parent_id: 1, name:'Жилье', is_living: false, is_social: false},
      {id:3, parent_id: 1, name:'Инженерия', is_living: false, is_social: false},
      {id:4, parent_id: 0, name:'Социальные объекты', is_living: false, is_social: true},
      {id:5, parent_id: 4, name:'БНК', is_living: false, is_social: false},
      {id:6, parent_id: 4, name:'ДОУ', is_living: false, is_social: false},
      {id:7, parent_id: 4, name:'Спорт - ФОК', is_living: false, is_social: false},
      {id:8, parent_id: 4, name:'ФОК', is_living: false, is_social: false},
      {id:9, parent_id: 4, name:'Школа', is_living: false, is_social: false},
      {id:10, parent_id: 4, name:'Поликлиника', is_living: false, is_social: false},
      {id:11, parent_id: 0, name:'Прочее', is_living: false, is_social: false},
      {id:12, parent_id: 11, name:'Дороги', is_living: false, is_social: false},
      {id:13, parent_id: 11, name:'Переход', is_living: false, is_social: false},
      {id:14, parent_id: 11, name:'Прочие', is_living: false, is_social: false},
    ]
  end

  def get_object_type_id_from_list
    list = Obj.objects_types_hierarchy
    # puts appointment
    appoint = list.find { |item|
      item[:name].mb_chars.downcase.to_s == appointment_adaptive.mb_chars.downcase.to_s
    }
    appoint.present? ? appoint[:id] : nil
  end

  def is_archive
    status_name=='Сдан'
  end

  def self.objects_regions
    @@objects_regions = []
    Obj.select(:region).distinct.each_with_index do |r, i|
      @@objects_regions.push ({:name => r.region, :id => i+1})
    end
    @@objects_regions
  end


  def self.banking_garanty_statuses
    infos = []
    ConstructionObject.only_active.includes(obj: [:object_bank_garantee]).all.each do |o|
      next if o.obj.nil?
      o.obj.object_bank_garantee.each_with_index  do |bg, index|
        infos << {id: o.id*1000+index, object_id: o.id ,
                  expected_receive_date: bg.date_end.to_time.to_i,
                  real_receive_date: (bg.is_closed=='Нет')? nil : bg.date_end.to_time.to_i}
      end
    end
    infos
  end


  def self.objects_payment
    works = []
    ObjectFinance.includes(obj: [:construction_object]).all.each do |of|
      next if of.obj.construction_object.nil?
      works << {
          id: of.id,
          object_id: of.obj.construction_object.id,
          prepay_payed: of.avans_pogasheno,
          prepay_not_payed: of.avans_ne_pogasheno,
          normal_payed: of.payed_without_avans,
          left_to_pay: of.payed_left
      }
    end
    works
  end

  def  self.object_perfomance
    perfomance = []
    ObjectFinance.includes(obj: [:construction_object]).all.each do |of|
      next if of.obj.construction_object.nil?
      perfomance << {
          id: of.id,
          object_id: of.obj.construction_object.id,
          payed: of.payed||0,
          left: of.work_left||0
      }
    end
    perfomance
  end

  def self.objects_budjets
    payments = []
    ObjectFinance.includes(obj: [:construction_object]).all.each do |of|
      next if of.obj.construction_object.nil?
      payments << {
          id: of.id,
          object_id: of.obj.construction_object.id,
          budjet: of.obj.construction_object.current_year_limit||0,
          budjet_spent: of.pay_current_year||0
      }
    end
    payments
  end

  def self.teps_list
    [
      {id: 1, name: 'Мощность'},
      {id: 2, name: 'Площадь квартир'},
      {id: 3, name: 'Квартирография'},
      {id: 4, name: 'Этажность'},
      {id: 5, name: 'Общая стоимость объекта по АИП'},
      {id: 6, name: 'Общая стоимость объекта по МГЭ'},
      {id: 7, name: 'Общая стоимость объекта по ПСС'},
      {id: 8, name: 'Срок ввода по контракту'},
      {id: 9, name: 'Срок ввода по плану'},
      {id: 10, name: 'Проектировщик'},
      {id: 11, name: 'Заказчик-застройщик'},
      {id: 12, name: 'Генподрядчик'},
    ]
  end


  def self.teps_values
    teps = []
    ConstructionObject.only_active_with_sql.each do |o|
      teps.push({id: "#{1}_#{o.id}", object_id: o.id, option_id: 1, value: "#{o.total_space||o.total_places} #{o.total_places.nil? ? 'м2' : 'мест' }" })
      teps.push({id: "#{2}_#{o.id}", object_id: o.id, option_id: 2, value: "#{o.living_space||'-'} м2" })
      teps.push({id: "#{3}_#{o.id}", object_id: o.id, option_id: 3, value: "1-ком: #{o.one_room_count||'–'} кв" })
      teps.push({id: "#{4}_#{o.id}", object_id: o.id, option_id: 3, value: "2-ком: #{o.two_room_count||'–'} кв" })
      teps.push({id: "#{5}_#{o.id}", object_id: o.id, option_id: 3, value: "3-ком: #{o.three_room_count||'–'} кв" })
      teps.push({id: "#{6}_#{o.id}", object_id: o.id, option_id: 3, value: "4-ком: #{o.four_room_count||'–'} кв" })
      teps.push({id: "#{7}_#{o.id}", object_id: o.id, option_id: 4, value: "#{o.floor_count||'–'}" })
      teps.push({id: "#{8}_#{o.id}", object_id: o.id, option_id: 5, value: "#{o.cost_limit||0}" })
      teps.push({id: "#{9}_#{o.id}", object_id: o.id, option_id: 6, value: "#{0}" })
      teps.push({id: "#{10}_#{o.id}", object_id: o.id, option_id: 7, value: "#{o.cost_limit}" })
      teps.push({id: "#{11}_#{o.id}", object_id: o.id, option_id: 8, value: "#{o.obj_getYearCorrect}" })
      teps.push({id: "#{12}_#{o.id}", object_id: o.id, option_id: 9, value: "#{o.obj_year_plan}" })
      teps.push({id: "#{13}_#{o.id}", object_id: o.id, option_id: 10, value: "#{o.obj_projector}" })
      teps.push({id: "#{14}_#{o.id}", object_id: o.id, option_id: 11, value: "#{o.obj_techinikal_customer}" })
      teps.push({id: "#{15}_#{o.id}", object_id: o.id, option_id: 12, value: "#{o.obj_general_builder}" })
    end
    teps
  end

  def self.key_dates
    [{id:1, name: 'Выход подрядчика на строй площадку'},
     {id:2, name: 'Сети'},
     {id:3, name: 'Строительные работы'},
     {id:4, name: 'Отделка'}]
  end

  def self.key_dates_values
    dates = []
    ConstructionObject.only_active.includes(obj: [:object_document]).all.each do |o|
      next if o.obj.nil?
      dates << {id: "#{1}_#{o.id}", date_id: 1, object_id: o.id, date: ObjectDocument.get_date_in_timestamps(o.obj.object_document.builder_enter_fact)}
      dates << {id: "#{2}_#{o.id}", date_id: 2, object_id: o.id, date: ObjectDocument.get_date_in_timestamps(o.obj.SMR_external_network)}
      dates << {id: "#{3}_#{o.id}", date_id: 3, object_id: o.id, date: ObjectDocument.get_date_in_timestamps(o.obj.SMR_constructive)}
      dates << {id: "#{4}_#{o.id}", date_id: 4, object_id: o.id, date: ObjectDocument.get_date_in_timestamps(o.obj.SMR_internal)}
    end
    dates
  end

  def self.additional_requirements
    [{id:1, name: 'Требуется ли отселение'},
     {id:2, name: 'Планируемая дата отселения'},
     {id:3, name: 'Фактическая дата отселения'},
     # {id:4, name: 'Размер компенсации'},
     {id:5, name: 'Требуется ли снос'},
     {id:6, name: 'Планируемая дата сноса'},
     {id:7, name: 'Фактическая дата сноса'},
     # {id:8, name: 'Размер компенсации'}
    ]
  end

  def evacuation_date_plan_humanized
    evacuation_date_plan.present? ? Date.parse(evacuation_date_plan.to_s) : '-'
  end

  def evacuation_date_humanized
    evacuation_date.present? ? Date.parse(evacuation_date.to_s) : '-'
  end

  def demolition_date_plan_humanized
    demolition_date_plan.present? ? Date.parse(demolition_date_plan.to_s) : '-'
  end

  def demolition_date_humanized
    demolition_date.present? ? Date.parse(demolition_date.to_s) : '-'
  end

  def self.additional_requirements_values
    values = []
    ConstructionObject.only_active_with_sql.each do |o|

      values<< {id: "#{1}_#{o.id}", requirement_id: 1, object_id: o.id, value: o.obj_evacuation_status||'-'}
      values<< {id: "#{2}_#{o.id}", requirement_id: 2, object_id: o.id, value: o.obj.evacuation_date_plan_humanized}
      values<< {id: "#{3}_#{o.id}", requirement_id: 3, object_id: o.id, value: o.obj.evacuation_date_humanized}
      # values<< {id: "#{4}_#{o.id}", requirement_id: 4, object_id: o.id, value: 'Неизвестно'}
      values<< {id: "#{5}_#{o.id}", requirement_id: 5, object_id: o.id, value: o.obj_demolition_status||'-'}
      values<< {id: "#{6}_#{o.id}", requirement_id: 6, object_id: o.id, value: o.obj.demolition_date_plan_humanized}
      values<< {id: "#{7}_#{o.id}", requirement_id: 7, object_id: o.id, value: o.obj.demolition_date_humanized}
      # values<< {id: "#{8}_#{o.id}", requirement_id: 8, object_id: o.id, value: 'Неизвестно'}
    end
    values
  end

  def self.object_works_groups
    [{id:1, name: 'ОСВОБОЖДЕНИЕ ПЛОЩАДКИ ОТ СЕТЕЙ'},
     {id:2, name: 'ПЕРЕКЛАДКА ИНЖЕНЕРНЫХ КОММУНИКАЦИЙ'},
     {id:3, name: 'ЭЛЕКТРОСНАБЖЕНИЕ'},
     {id:4, name: 'ТЕПЛОСНАБЖЕНИЕ'},
     {id:5, name: 'ВОДОСНАБЖЕНИЕ'},
     {id:6, name: 'КАНАЛИЗАЦИЯ'},
     {id:7, name: 'ВОДОСТОК'},
     {id:8, name: 'СЕТИ СВЯЗИ'}]
  end


  def self.object_works_values
    values = []
    EngeneeringNetworkLink.includes(:construction_object).each do |w|
      values<< {id: w.id, work_id: w.network_id, object_id: w.construction_object.id, value: w.percentage||'-'}
    end
    values
  end

  def self.object_tenders_list
    values = []
    ObjectTender.all.each do |t|
      next if t.obj.nil? || t.obj.construction_object.nil?
      next if t.obj.construction_object.is_active==false
      next if t.TenderStatus!='проведен'
      values << {
          object_id: t.obj.construction_object.id,
          contractor_id: t.organization_id,
          type_id: t.type_new||-1,
          status: t.status,
          date_start: t.date_start.nil? ? nil : t.date_start.to_time.to_i,
          date_finish: t.date_finish.nil? ? nil : t.date_finish.to_time.to_i,
          price_start: t.price_begin,
          price_finish: t.price_end,
          request_filed_count: t.bid_all,
          request_accepted_count: t.bid_accept
      }
    end
    values
  end

  def self.smr_info
    values = []
    ConstructionObject.only_active_with_sql.each do |o|
      next if o.obj.nil?
      smr_work = o.obj.get_object_finance_by_type(1).take
      next if smr_work.nil?
      values<< { id: smr_work.id,
                  object_id: o.id,
                  contract_name: (smr_work.organization_name||'') +
                      ' по договору '+ (smr_work.document_number||''),
                  prepay_payed: (smr_work.avans_pogasheno||0).round,
                  prepay_not_payed:(smr_work.in_avance_work||0).round,
                  normal_payed: (smr_work.payed_for_work||0).round,
                  left_to_pay: (smr_work.pay_left||0).round,
                  payed: smr_work.work_comlete||0,
                  left: smr_work.work_left||0
      }
    end
    values
  end


  def self.api_response
    {
        :objectType => Obj.objects_types_hierarchy,
        :objectRegion => Prefektura.all.inject([]){|array,pref| array<<{name:pref.prefektura_name, id: pref.id}},
        :objects => ConstructionObject.all_objects_json,
        :landPassport => ConstructionObject.land_passports,
        :expertise => ConstructionObject.expertises,
        :buildingPermit => ConstructionObject.permits,
        :bankGuarantee => Obj.banking_garanty_statuses,
        :buildingDemolition => ConstructionObject.demolitions,
        :objectWorkPayment => Obj.objects_payment,
        :objectPerformance => Obj.object_perfomance,
        :objectBudget => Obj.objects_budjets,
        :objectMontageWorks => Obj.smr_info,
        :optionName => Obj.teps_list,
        :optionValue => Obj.teps_values,
        :objectDocumentName => DocumentType.all.inject(DocumentType.fake_documents_types){|array,doc| array<<{name:doc.doc_type, id: doc.id*10}},
        :objectDocumentCategoryName => ObjectDocument.document_categories,
        :objectDocumentCategory => DocumentType.all.inject(DocumentType.fake_documents_type_cats){|array,doc| array<<{id: doc.id*10, type_id: doc.id*10, category_id: 1 }},
        :objectDocument => ConstructionObject.documents_statuses,
        :objectProductionDateName => Obj.key_dates,
        :objectProductionDate => Obj.key_dates_values,
        :objectAdditionalRequirementName => Obj.additional_requirements,
        :objectAdditionalRequirement => Obj.additional_requirements_values,
        :objectEngineeringWorkCategoryName => [{id:1, name: 'Все работы'}],
        :objectEngineeringWorkCategory => ExternalEngeneeringNetwork.all.inject([]){|array,work| array<<{category_id:1, work_id: work.id}},
        :objectEngineeringWorkName => ExternalEngeneeringNetwork.all.inject([]){|array,work| array<<{name:work.network_alias, id: work.id}},
        :objectEngineeringWork => Obj.object_works_values,
        :objectVisitDate => ConstructionObject.all.inject([]){|array,visit| array<<{object_id:visit.id,
                                                                                    date: visit.techincal_state_date.nil? ? 0 : (visit.techincal_state_date).to_time.to_i}},
        :objectWorkPerformanceName => [{id:1, parent_id: 0, name: "Вся информация"}],
        :objectWorkPerformance => ConstructionObject.all.inject([]){|array,visit| array<<{work_id:1, object_id: visit.id,percent: visit.technical_state}},
        :auction => Obj.object_tenders_list,
        :auctionType => [
            {id: "1", name: 'Перепроектирование' },
            {id: "2", name: 'Генподрядчик' },
            {id: "3", name: 'ТЗ СМР' },
            {id: "4", name: 'Генпроектировщик' },
            {id: "5", name: 'ТЗ ПИР и СМР' },
            {id: "6", name: 'Страхование СМР' },
            {id: "7", name: 'Управляющая компания' },
            {id: "0", name: 'Другое' },
        ]
    }
  end

end
