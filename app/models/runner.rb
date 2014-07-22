class Runner < ActiveRecord::Base
  has_many :markets, through: :market_runners
  has_many :market_runners

  def self.load(runner)
    Runner.where(api_id: runner.selection_id).first_or_create(
      api_id: runner.selection_id,
      name: runner.runner_name
    )
  end
end

