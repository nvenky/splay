class AddIndexMarketRunner < ActiveRecord::Migration
  class MarketRunner < ActiveRecord::Base
    belongs_to :market
    belongs_to :runner
    def self.dedupe
      # find all models and group them on keys which should be common
      grouped = all.group_by{|model| [model.market, model.runner] }
      grouped.values.each do |duplicates|
        duplicates.shift # or pop for last one
        duplicates.each{|double| double.destroy} # duplicates can now be destroyed
      end
    end
  end
  def change
    MarketRunner.dedupe
    add_index :market_runners, [:market_id, :runner_id], unique: true
  end
end
