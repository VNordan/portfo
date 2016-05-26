class AddCompanyIdToTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.integer  :company_id
    end
  end
end
