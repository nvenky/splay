class ReplaceMarketTableWithPrimaryKey < ActiveRecord::Migration

  class Market < ActiveRecord::Base
    belongs_to :event
    has_many :market_runners
  end

  class MarketRunner < ActiveRecord::Base
    belongs_to :market
    belongs_to :runner

  end

  class NewMarket < ActiveRecord::Base
    belongs_to :event
    has_many :new_market_runners
  end

  class NewMarketRunner < ActiveRecord::Base
    belongs_to :new_market, foreign_key: :market_id
    belongs_to :runner
  end

  class Runner < ActiveRecord::Base
    self.primary_key = 'api_id'
    has_many :new_market_runners
  end


  def up
    create_table :new_markets do |t|
      t.integer :api_id
      t.integer :exchange_id
      t.string :betting_type
      t.timestamp :start_time
      t.string :name
      t.string :market_type
      t.belongs_to :event
      t.string :status, default: 'OPEN'
    end
    add_foreign_key(:new_markets, :events, primary_key: :api_id)

    create_table :new_market_runners do |t|
      t.integer :market_id, index: true
      t.integer :runner_id, index: true
      t.decimal :actual_sp
      t.string :status
    end
    add_foreign_key(:new_market_runners, :new_markets, column: :market_id)
    add_foreign_key(:new_market_runners, :runners, primary_key: :api_id)

    migrate_existing_records
  end

  def down
    drop_table :new_market_runners
    drop_table :new_markets
  end

  def migrate_existing_records
    Market.all.each do |market|
      new_market = NewMarket.create(market.attributes)
      market.market_runners.each do |market_runner|
        NewMarketRunner.create(new_market: new_market, runner: market_runner.runner)
      end
    end
  end

end
