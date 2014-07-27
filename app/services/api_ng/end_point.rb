module ApiNg
  class EndPoint
    def self.markets(event_type_id)
      MarketCatalogue.new(:aus, [event_type_id]).call + MarketCatalogue.new(:uk, [event_type_id]).call
    end

    def self.get_closed_markets(market_ids)
       MarketBook.new(:aus, market_ids).call.select{|m| m.status == 'CLOSED'} +
       MarketBook.new(:uk, market_ids).call.select{|m| m.status == 'CLOSED'}
    end

    def self.event_types
       EventTypes.new(:aus).call + EventTypes.new(:uk).call
    end
  end
end
