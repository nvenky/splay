class ReplaceRunnerTableWithPrimaryKey < ActiveRecord::Migration

  class Runner < ActiveRecord::Base
    has_many :market_runners
  end
  class MarketRunner < ActiveRecord::Base
    belongs_to :market
    belongs_to :runner
  end

  class Old2MarketRunner < ActiveRecord::Base
    belongs_to :market
    belongs_to :old_runner, foreign_key: :runner_id
  end

  class OldRunner < ActiveRecord::Base
    has_many :old2_market_runners, foreign_key: :runner_id
  end

  def up
    rename_table :market_runners, :old2_market_runners
    rename_table :runners, :old_runners

    create_table :runners do |t|
      t.integer :api_id
      t.integer :exchange_id
      t.string :name
    end

    create_table :market_runners do |t|
      t.integer :market_id, index: true
      t.integer :runner_id, index: true
      t.decimal :actual_sp
      t.string :status
    end

    add_foreign_key(:market_runners, :markets)
    add_foreign_key(:market_runners, :runners)

    migrate_existing_records
  end

  def down
    drop_table :market_runners
    drop_table :runners

    rename_table :old_runners, :runners
    rename_table :old2_market_runners, :market_runners
  end

  def migrate_existing_records
    OldRunner.all.each do |old_runner|
      attr = old_runner.attributes
      attr.delete(:id)
      attr[:exchange_id] = 2
      runner = Runner.create(attr)
      old_runner.old2_market_runners.each do |old_market_runner|
        MarketRunner.create(market: old_market_runner.market, runner: runner,
                            actual_sp: old_market_runner.actual_sp, status: old_market_runner.status)
      end
    end
  end

end

