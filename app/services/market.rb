class Market < ApiNg::JsonRpc
  include ApiNg::SportsURI

  def initialize(exchange, params={})
    super exchange, params
  end

  def method_name
    'listEventTypes'
  end

  def default_params
    {'filter' => {}}
  end

  class MultiExchange
    include ApiNg::MultiExchangeBase

    def merge_results(au_result, uk_result)
      (au_result + uk_result).uniq { |event_type_hash| event_type_hash[:eventType][:id] }
    end
  end
end
