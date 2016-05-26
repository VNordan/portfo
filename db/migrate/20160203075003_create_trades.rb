class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :out_id, limit: 8
      t.string  :contract_number
      t.string  :trade_status
      t.float   :starting_price
      t.string  :winner
      t.float   :winners_price
      t.date    :trade_date
      t.string  :trade_type
      t.integer :lot_id, limit: 8
      t.integer :object_id, limit: 8
      t.integer :participants_count
      
      t.timestamps null: false
    end
  end
end
