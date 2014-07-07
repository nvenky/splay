class MarketRunner < ActiveRecord::Base
  belongs_to :market
  belongs_to :runner
  default_scope { order('actual_sp ASC')}
  scope :winners_losers, -> {where("status in ('WINNER', 'LOSER')")}

  def winner?
    status == 'WINNER'
  end
end

