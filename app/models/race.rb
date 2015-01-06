class Race
   include Mongoid::Document
   include Mongoid::Attributes::Dynamic

   def self.load
       existing_markets = Race.pluck(:market_id)
       grp_count = 0
       Market.includes([market_runners: [:runner], event: [:venue, :event_type]]).closed.find_in_batches do |group|
       p "Group - #{grp_count+=1} size - #{group.size}"
       group.each { |market| 
           Race.create(market.as_json) unless existing_markets.include?(market.id)
       }
     end
   end
end
