class Market < ActiveRecord::Base
  self.primary_key = 'api_id'

  belongs_to :event
  has_many :market_runners
  has_many :runners, through: :market_runners, dependent: :delete_all


  def self.load(event_type_id)
    event_type = EventType.find(event_type_id)
    markets = ApiNg::MarketCatalogue.new([event_type_id]).call
    markets.each do |market|
      exchange_id, api_id = market.market_id.split('.')
      m = Market.where(api_id: api_id).first_or_create(
        api_id: api_id,
        exchange_id: exchange_id,
        event: Event.load(event_type, market.event),
        name: market.market_name,
        market_type: market.description.market_type,
        start_time: market.description.market_time,
        betting_type: market.description.betting_type
      )
      m.load_runners(market.runners)
    end
  end

  def load_runners(runners)
    runners.each do |runner|
      MarketRunner.where(runner: Runner.load(runner), market: self).first_or_create
    end
  end
end
