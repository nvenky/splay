require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1d' do
  EventType.load
end

scheduler.every '1h' do
  EventType.where("name like '%Racing'").each do |event_type|
    Market.load event_type.api_id
  end
end

scheduler.every '10m' do
  Market.update_closed_markets
end
