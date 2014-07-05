class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets, {id: false, primary_key: :api_id} do |t|
      t.primary_key :api_id
      t.integer :exchange_id
      t.string :betting_type
      t.date :start_time
      t.string :name
      t.string :market_type
      t.belongs_to :event
      t.string :status, default: 'OPEN'
    end
    add_foreign_key(:markets, :events, primary_key: :api_id)
  end
end
