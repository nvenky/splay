module ApiNg
  class MarketBook < ServiceBase

    def initialize(exchange, market_ids)
      super(exchange)
      @market_ids = market_ids
    end

    def method_name
      'listMarketBook'
    end

    def default_params
      {'marketIds' =>  @market_ids, 'priceProjection' => {'priceData' => ['SP_AVAILABLE']}}
    end

  end
end
