class ReplaceMarketTableWithPrimaryKey < ActiveRecord::Migration

  class Market < ActiveRecord::Base
    belongs_to :event
    has_many :market_runners
  end

  class MarketRunner < ActiveRecord::Base
    belongs_to :market
    belongs_to :runner
  end

  class OldMarket < ActiveRecord::Base
    belongs_to :event
    has_many :old_market_runners, foreign_key: :market_id
  end

  class OldMarketRunner < ActiveRecord::Base
    belongs_to :old_market, foreign_key: :market_id
    belongs_to :runner
  end

  class Runner < ActiveRecord::Base
    self.primary_key = 'api_id'
    has_many :market_runners
  end


  def up
    rename_table :market_runners, :old_market_runners
    rename_table :markets, :old_markets

    create_table :markets do |t|
      t.integer :api_id
      t.integer :exchange_id
      t.string :betting_type
      t.timestamp :start_time
      t.string :name
      t.string :market_type
      t.belongs_to :event
      t.string :status, default: 'OPEN'
    end
    add_foreign_key(:markets, :events, primary_key: :api_id)

    create_table :market_runners do |t|
      t.integer :market_id, index: true
      t.integer :runner_id, index: true
      t.decimal :actual_sp
      t.string :status
    end

    add_foreign_key(:market_runners, :markets)
    add_foreign_key(:market_runners, :runners, primary_key: :api_id)

    migrate_existing_records
  end

  def down
    drop_table :market_runners
    drop_table :markets

    rename_table :old_market_runners, :market_runners
    rename_table :old_markets, :markets
  end

  def migrate_existing_records
    OldMarket.all.each do |old_market|
      market = Market.create(old_market.attributes)
      old_market.old_market_runners.each do |old_market_runner|
        MarketRunner.create(market: market, runner: old_market_runner.runner,
                            actual_sp: old_market_runner.actual_sp, status: old_market_runner.status)
      end
    end
  end

end
