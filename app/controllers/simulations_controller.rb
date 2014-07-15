class SimulationsController < ApplicationController
  def new
    @venues = Venue.pluck(:name)
  end

  def run
    scenario = Scenario.new(params[:scenarios].symbolize_keys)
    simulation = Simulation.new(params[:commission].to_d)
    simulation.scenarios << scenario

    winnings_series = ['Winnings']
    summary_series = ['Summary']
    total = 0

    market_filter.each_with_index do |market, index|
      amount = market.profit_loss(simulation)
      total += amount
      winnings_series << amount.round(2).to_f
      summary_series << total.round(2).to_f
    end
    render json: [winnings_series, summary_series]
  end

  private

  def market_filter
    markets = Market.closed
    markets = markets.joins(:event => :venue).where(['venues.name = ?', params[:venue]]) unless params[:venue].blank?
    markets = markets.where(['start_time > ?', DateTime.strptime(params[:start_date], "%d/%m/%Y")]) unless params[:start_date].blank?
    markets = markets.market_type(params[:market_type]) unless params[:market_type].blank?
    markets
  end
end
