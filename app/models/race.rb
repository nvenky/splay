class Race
   include Mongoid::Document
   include Mongoid::Attributes::Dynamic

   def self.load
     Market.includes([market_runners: [:runner], event: [:venue, :event_type]]).closed.find_in_batches do |group|
       group.each { |market| 
		   Race.create(market.as_json) unless Race.where(_id: market.id).exists?
       }
     end
   end
end
