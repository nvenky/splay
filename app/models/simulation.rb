class Simulation
  attr_accessor :scenarios, :commission
  def initialize(commission)
    @commission = commission
    @scenarios = []
  end
end
