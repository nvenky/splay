class MarketRunner < ActiveRecord::Base
  belongs_to :market
  belongs_to :runner
end

