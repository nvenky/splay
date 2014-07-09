class SimulationsController < ApplicationController
  def new
    @simulation = Simulation.new
  end

  def run
    scenario = Scenario.new(params[:scenarios].symbolize_keys)
    simulation = Simulation.new
    simulation.scenarios << scenario

    winnings_series = ['Winnings']
    summary_series = ['Summary']
    total = 0

    markets = Market.closed
    markets = markets.market_type(params[:market_type]) unless params[:market_type].blank?
    markets.each_with_index do |market, index|
      amount = market.profit_loss(simulation.scenarios)
      total += amount
      winnings_series << amount.round(2).to_f
      summary_series << total.round(2).to_f
    end
    render json: [winnings_series, summary_series]
  end
end
