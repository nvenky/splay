class Market < ActiveRecord::Base
  self.primary_key = 'api_id'

  belongs_to :event
  has_many :market_runners
  has_many :runners, through: :market_runners, dependent: :delete_all

  scope :open_after_start_time, -> { where("start_time < '#{Time.now - 10.minutes}' and status = 'OPEN'" ) }
  scope :market_type, ->(market_type) {where "market_type = '#{market_type}'"}
  scope :closed, -> {where ("status = 'CLOSED'")}

  def self.load(event_type_id)
    Rails.logger.debug 'LOADING MARKETS'
    event_type = EventType.find(event_type_id)
    last_fetch_time = Market.includes(:event).where('events.event_type_id = ?', event_type_id).maximum(:start_time)
    last_fetch_time = last_fetch_time + 1.second if last_fetch_time
    markets = ApiNg::MarketCatalogue.new([event_type_id], last_fetch_time).call
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
    closed_markets = ApiNg::MarketBook.new(market_ids).call.select{|m| m.status == 'CLOSED'}
    closed_markets.each do |market|
      api_id = market.market_id.split('.').last
      m = Market.find(api_id)
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
      mr = MarketRunner.where(runner: runner.selection_id, market: self).first
      mr.status = runner.status
      mr.actual_sp = runner.sp.actual_sp if runner.sp
      mr.save!
    end
  end

  def profit_loss(scenarios)
    scenarios.inject(0) do |total, scenario|
      total += scenario_profit_loss(scenario)
    end
  end

  def to_json
    {
      market_type: market_type,
      venue: event.venue.name,
      number_of_runners: runners.size,
      winning_runners: runners

    }
  end

  private

  def scenario_profit_loss(scenario)
    total = 0
    positions = scenario.positions(runners.size)
    runners.each_with_index do |runner, index|
      if positions.include?(index) and runners[index].actual_sp
        total += runners[index].winner? ? runner_winning_amount(scenario, runner.actual_sp) : runner_losing_amount(scenario, runner.actual_sp)
      end
    end
    total
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
