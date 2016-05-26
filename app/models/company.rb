class Company < ActiveRecord::Base
  has_many :trades, foreign_key: 'company_id', primary_key: 'id'

  def self.list
    orgs = [];
    Company.all.each do |c|
      orgs << {
          id: c.id,
          name: c.company_title,
          object_count: (c.objects_count||0).to_s,
          contest_win_count: (c.trades.count||0).to_s,
          ceo: 'ФИО Генерального Директора',
          address: 'Юр Адрес'
      }
    end
    orgs
  end

  def objects_count
    Trade.where(company_id: self.id).distinct(:object_id).count
  end


  def self.contacts
    contacts = [];
    Company.all.each do |o|
      contacts << {
          contractor_id: o.id,
          type: 1,
          value: '8-888-888-88-88'
      }
      contacts << {
          contractor_id: o.id,
          type: 2,
          value: 'mail@mail.com'
      }
    end
    contacts
  end

  def self.organizations_budjets
    orgs = [];
    Company.all.each do |o|
      orgs << {
          contractor_id: o.id,
          payed: 10000,
          left: 10000
       # payed: o.work_complete_summ_for_all_objects,
       #    left: o.work_left_summ_for_all_objects
      }
    end
    orgs
  end

  def self.organizations_parts_in_sum
    orgs = [];
    Company.all.each do |o|
      o.trades.group("EXTRACT(YEAR from trade_date)").sum('winners_price').each do |year, summT|
        orgs << {
            contractor_id: o.id,
            date: Date.parse("#{year}-01-01").to_time.to_i,
            sum: summT
        }
      end
    end
    orgs
  end

  def self.organizations_parts_in_amount
    orgs = [];
    Company.all.each do |o|
      o.trades.group("EXTRACT(YEAR from trade_date)").distinct('object_id').count.each do |year, count|
        orgs << {
            contractor_id: o.id,
            date: Date.parse("#{year}-01-01").to_time.to_i,
            count: count
        }
      end
    end
    orgs
  end


  def self.organizations_payment
    orgs = [];
    Company.all.each do |o|
      orgs << {
          contractor_id: o.id,
          prepay_payed: 10000,
          prepay_not_payed: 10000,
          normal_payed: 10000,
          left_to_pay: 10000

      # prepay_payed: o.avans_pagasheno_for_all_objects,
      #     prepay_not_payed: o.avans_not_pagasheno_for_all_objects,
      #     normal_payed: o.payed_for_work_for_all_objects,
      #     left_to_pay: o.residue_summ_for_all_objects
      }
    end
    orgs
  end

  def self.organizations_contracts
    contracts = []
    Trade.includes(:company, construction_object: [:obj]).each do |trade|
      next if trade.company.nil? || trade.construction_object.nil?
      obj = trade.construction_object.obj
      next if obj.nil?
      contracts << {
          contractor_id: trade.company_id,
          object_id: trade.object_id,
          status: obj.status_name,
          network: "#{obj.SMR_external_network||'-'}/#{obj.SMR_external_network_delay||0}",
          erection: "#{obj.SMR_constructive||'-'}/#{obj.SMR_constructive_delay||0}",
          finishing: "#{obj.SMR_internal||'-'}/#{obj.SMR_internal_delay||0}"
      }
    end
    contracts
  end

end
