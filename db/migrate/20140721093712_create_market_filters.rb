class CreateMarketFilters < ActiveRecord::Migration
  def change
    create_table :market_filters do |t|
      t.string :filter_name
      t.string :event_type
      t.string :market_type
      t.timestamp :start_date
      t.string :territory
      t.string :venue_class
      t.string :tier
      t.string :venue_name
      t.belongs_to :user, index: true
    end
  end
end
