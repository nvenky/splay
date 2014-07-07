class JobsController < ApplicationController
  def load_event_types
    EventType.load
    render text: 'Load event types Success'
  end

  def load_markets
    Market.load EventType.where("name like 'Horse%'").first.api_id
    Market.load EventType.where("name like 'Greyhound%'").first.api_id
    render text: 'Load market Success'
  end

  def update_markets
    Market.update_closed_markets
    render text: 'Update market Success'
  end
end

