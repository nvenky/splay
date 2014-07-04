class Market < ActiveRecord::Base
  self.primary_key = 'api_id'

  belongs_to :event_type
  has_many :runners, dependent: :delete_all


  def self.load(event_type_id)
    event_type = EventType.find(event_type_id)
    markets = ApiNg::MarketCatalogue.new([event_type_id]).call
    markets.each do |market|
      m = Market.where(api_id: market.market_id).first_or_create
      m.name = market.market_name
      m.market_type = market.description.market_type
      market.runners.each do |runner|
        r = Runner.where(api_id: runner.selection_id).first_or_create
        r.market_id = m.api_id
        r.api_id = runner.selection_id
        r.name = runner.runner_name
        r.save!
      end
      m.event_type = event_type
      m.save!
    end
  end
end


