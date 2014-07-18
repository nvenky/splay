module ApiNg
  class MarketCatalogue < ApiNg::JsonRpc
    include ApiNg::SportsURI

    def initialize(event_type_ids, market_start_time_loaded)
      super(:aus)
      @event_type_ids = event_type_ids
      @market_start_time_loaded = market_start_time_loaded
    end

    def method_name
      'listMarketCatalogue'
    end

    def default_params
      market_filter = {
        'eventTypeIds' => @event_type_ids,
        'bspOnly' => true
      }
      #market_filter['marketStartTime'] = {'from' => @market_start_time_loaded.iso8601} if @market_start_time_loaded

      {'filter' => market_filter,
       'marketProjection' => ['EVENT', 'MARKET_DESCRIPTION', 'RUNNER_DESCRIPTION'],
       'sort' => 'FIRST_TO_START',
       'maxResults' => 100}
    end
  end
end
