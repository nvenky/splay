class SimulationsController < ApplicationController
  def new
    @venues = Venue.unique_filters
    @event_types = EventType.where("name like '%Racing'")
  end

  def run
    scenario = Scenario.new(params[:scenarios].symbolize_keys)
    simulation = Simulation.new(params[:commission].to_d)
    simulation.scenarios << scenario

    winnings_series = ['Winnings']
    summary_series = ['Summary']
    market_details = []
    total = 0

    market_filter.each_with_index do |market, index|
      amount = market.profit_loss(simulation)
      if amount != 0
        total += amount
        winnings_series << amount.round(2).to_f
        summary_series << total.round(2).to_f
        market_details << market_detail(market, amount.round(2).to_f)

      end
    end
    render json: {chart_data: [winnings_series, summary_series], market_details: market_details}
  end

  private

  def market_filter
    markets = Market.joins(:event => :venue).closed
    markets = markets.where(['venues.territory= ?', params[:venue_territory]]) unless params[:venue_territory].blank?
    markets = markets.where(['venues.venue_class = ?', params[:venue_class]]) unless params[:venue_class].blank?
    markets = markets.where(['venues.tier = ?', params[:venue_tier]]) unless params[:venue_tier].blank?
    markets = markets.where(['venues.name = ?', params[:venue_name]]) unless params[:venue_name].blank?
    markets = markets.where(['events.event_type_id = ?', params[:event_type_id]]) unless params[:event_type_id].blank?
    markets = markets.where(['start_time > ?', DateTime.strptime(params[:start_date], "%d/%m/%Y")]) unless params[:start_date].blank?
    markets = markets.market_type(params[:market_type]) unless params[:market_type].blank?
    markets
  end

  def venue_unique_values(field)
    Venue.uniq.pluck(field).compact.sort
  end

  def market_detail(market, profit_loss)
    {
      start_time: market.start_time.in_time_zone('Melbourne').strftime('%d-%m-%Y %H:%M:%S'),
            event_type: market.event.event_type.name,
            market_type: market.market_type,
            venue: market.event.venue.name,
            name: market.name,
            runners_summary: market.runners_sp_summary,
            amount: profit_loss
    }
  end
end
