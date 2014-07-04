class Runner < ActiveRecord::Base
  self.primary_key = 'api_id'

  belongs_to :market

end

