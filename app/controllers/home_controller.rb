class HomeController < ApplicationController
  def new
    @venues = Venue.unique_filters
    @event_types = EventType.where("name like '%Racing'")
  end
end
