class CreateMarketTable < ActiveRecord::Migration
  def change
    create_table :markets, {id: false, primary_key: :api_id} do |t|
      t.string :api_id
      t.string :name
      t.string :market_type
      t.belongs_to :event_type
    end
    execute "ALTER TABLE markets ADD PRIMARY KEY (api_id);"
    add_foreign_key(:markets, :event_types, primary_key: :api_id)
  end
end
