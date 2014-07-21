module ApiNg
  class MarketCatalogue < ApiNg::JsonRpc
    include ApiNg::SportsURI

    def initialize(event_type_ids)
      super(:aus)
      @event_type_ids = event_type_ids
    end

    def method_name
      'listMarketCatalogue'
    end

    def default_params
      market_filter = {
        'eventTypeIds' => @event_type_ids,
        'bspOnly' => true
      }

      {'filter' => market_filter,
       'marketProjection' => ['EVENT', 'MARKET_DESCRIPTION', 'RUNNER_DESCRIPTION'],
       'sort' => 'FIRST_TO_START',
       'maxResults' => 100}
    end
  end
end
