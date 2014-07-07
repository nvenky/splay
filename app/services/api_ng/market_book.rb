module ApiNg
  class MarketBook < ApiNg::JsonRpc
    include ApiNg::SportsURI

    def initialize market_ids
      super
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
