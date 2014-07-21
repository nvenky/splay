class JobsController < ApplicationController

  def run
    load_event_types
    load_markets
    update_markets
    render text: 'Jobs completed successfully'
  end

  private
  def load_event_types
    EventType.load
  end

  def load_markets
    Market.load EventType.where("name like 'Horse%'").first.api_id
    Market.load EventType.where("name like 'Greyhound%'").first.api_id
  end

  def update_markets
    Market.update_closed_markets
  end
end

