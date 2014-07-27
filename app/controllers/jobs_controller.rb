class JobsController < ApplicationController

  def run
    load_event_types
    load_markets
    update_markets
    render json: {load_event_types: load_event_types, load_markets: load_markets, update_markets: update_markets}
  end

  def load_event_types
    with_exception_handling do
      EventType.load
    end
  end

  def load_markets
    with_exception_handling do
      Market.load EventType.find_by("name like 'Horse%'").api_id
      Market.load EventType.find_by("name like 'Greyhound%'").api_id
    end
  end

  def update_markets
    with_exception_handling do
      Market.update_closed_markets
    end
  end

  private
  def with_exception_handling
    begin
      yield
      'SUCCESS'
    rescue Exception => e
      "FAILED #{e.inspect}"
    end
  end
end

