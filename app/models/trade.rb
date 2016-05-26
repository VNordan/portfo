class Trade < ActiveRecord::Base
  belongs_to :construction_object,  foreign_key: 'object_id'
  belongs_to :company, foreign_key: 'company_id'

  def self.tender_types

    values = [];
    id = 0
    Trade.select('distinct(trade_type)').each_with_index  do |type|
      values << {id: id, name: type.trade_type }
      id += 1
    end
    values
  end
end
