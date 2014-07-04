module ApiNg
  class MarketCatalogue < ApiNg::JsonRpc
    include ApiNg::SportsURI

    def initialize(event_type_ids)
      super
      @event_type_ids = event_type_ids
    end

    def method_name
      'listMarketCatalogue'
    end

    def default_params
      {'filter' => {'eventTypeIds' => @event_type_ids, 'bspOnly' => true},
       'marketProjection' => ['EVENT', 'MARKET_DESCRIPTION', 'RUNNER_DESCRIPTION'],
       'maxResults' => 1}
    end
  end
end
