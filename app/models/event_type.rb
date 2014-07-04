class EventType < ActiveRecord::Base
  self.primary_key = 'api_id'
  has_many :markets, dependent: :delete_all

  def self.load
    event_types = ApiNg::EventTypes.new.call
    event_types.each do |event_type_hash|
      e = EventType.where(api_id: event_type_hash[:eventType][:id].to_i).first_or_create
      e.name = event_type_hash[:eventType][:name]
      e.save
    end
  end
end
