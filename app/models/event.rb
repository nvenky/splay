class Event < ActiveRecord::Base
  belongs_to :venue
  belongs_to :event_type

  has_many :markets

  def self.load(event_type, event)
    Event.where(api_id: event.id).first_or_create(
      api_id: event.id,
      event_type: event_type,
      venue: Venue.load(event),
      name: event.name
    )
  end

end

