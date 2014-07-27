class Venue < ActiveRecord::Base
  has_many :events


  def self.load(event)
    Venue.where(name: event.venue, country_code: event.country_code).first_or_create
  end

  def self.unique_filters
    { name: unique_values(:name),
      territory: unique_values(:territory),
      venue_class: unique_values(:venue_class),
      tier: unique_values(:tier)
    }
  end

  private
  def self.unique_values(field)
    Venue.uniq.pluck(field).compact.sort
  end
end

