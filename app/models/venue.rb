class Venue < ActiveRecord::Base
  has_many :events


  def self.load(event)
    Venue.where(name: event.venue, country_code: event.country_code).first_or_create
  end
end

