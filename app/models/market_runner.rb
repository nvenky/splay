class MarketRunner < ActiveRecord::Base
  belongs_to :market
  belongs_to :runner
  default_scope { where("status in ('WINNER', 'LOSER')").order('actual_sp ASC')}

  def winner?
    status == 'WINNER'
  end
end

