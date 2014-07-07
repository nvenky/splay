class Runner < ActiveRecord::Base
  self.primary_key = 'api_id'

  has_many :markets, through: :market_runners
  has_many :market_runners
  #attr_accessor :status, :actual_sp

  def self.load(runner)
    Runner.where(api_id: runner.selection_id).first_or_create(
      api_id: runner.selection_id,
      name: runner.runner_name
    )
  end
end

