class Market < ActiveRecord::Base
  belongs_to :event
  has_many :market_runners
  has_many :runners, through: :market_runners, dependent: :delete_all

  scope :open_after_start_time, -> { where("start_time < '#{Time.now - 10.minutes}' and status = 'OPEN'" ) }
  scope :market_type, ->(market_type) {where "market_type = '#{market_type}'"}
  scope :closed, -> {where ("status = 'CLOSED'")}

  default_scope { order('start_time ASC')}

  def self.load(event_type_id)
    Rails.logger.debug 'LOADING MARKETS'
    event_type = EventType.find(event_type_id)
    markets = ApiNg::EndPoint.markets(event_type_id)
    markets.each do |market|
      exchange_id, api_id = market.market_id.split('.')
      m = Market.where(api_id: api_id).first_or_create(
        api_id: api_id,
        exchange_id: exchange_id,
        event: Event.load(event_type, market.event),
        name: market.market_name,
        market_type: market.description.market_type,
        start_time: DateTime.iso8601(market.description.market_time),
        betting_type: market.description.betting_type
      )
      m.load_runners(market.runners)
    end
  end

  def self.update_closed_markets
    Rails.logger.debug 'UPDATING CLOSED MARKETS'
    market_ids = open_after_start_time.limit(50).select([:exchange_id, :api_id]).map{|m| "#{m.exchange_id}.#{m.api_id}"}
    closed_markets = ApiNg::EndPoint.get_closed_markets(market_ids)
    closed_markets.each do |market|
      exchange_id, api_id = market.market_id.split('.')
      m = Market.find_by(exchange_id: exchange_id, api_id: api_id)
      m.update_runners(market.runners)
      m.status = market.status
      m.save!
    end
  end

  def load_runners(runners)
    runners.each do |runner|
      MarketRunner.where(runner: Runner.load(runner), market: self).first_or_create
    end
  end

  def update_runners(runners)
    runners.each do |runner|
      mr = MarketRunner.joins(:runner).where(['runners.api_id = ? and market_id = ?', runner.selection_id, self.id]).first
      mr.status = runner.status
      mr.actual_sp = runner.sp.actual_sp if runner.sp
      mr.save!
    end
  end

  def profit_loss(simulation)
    simulation.scenarios.inject(0) do |total, scenario|
      total += scenario_profit_loss(simulation.commission, scenario)
    end
  end

  def runners_sp_summary
    runners.map do |runner|
      "#{runner.actual_sp.round(2).to_f}(#{runner.winner? ? 'W' : 'L'})"
    end.join('; ')

  end

  private

  def scenario_profit_loss(commission, scenario)
    total = 0
    positions = scenario.positions(runners.size)
    runners.each_with_index do |runner, index|
      if positions.include?(index) and runner.actual_sp and scenario.odds_in_range?(runner.actual_sp)
        total += runner.winner? ? runner_winning_amount(scenario, runner.actual_sp) : runner_losing_amount(scenario, runner.actual_sp)
      end
    end
     total > 0 ? total * ((100 - commission)/100) : total
  end

  def runner_winning_amount(scenario, sp)
    if scenario.back?
      (scenario.size * sp) - scenario.size
    elsif scenario.lay?
      -((scenario.size * sp) - scenario.size)
    else
      -scenario.size
    end
  end

  def runner_losing_amount(scenario, sp)
    if scenario.back?
      -scenario.size
    elsif scenario.lay?
      scenario.size
    else
      scenario.size / sp
    end
  end

  def runners
    @runners ||= market_runners.winners_losers
  end
end
