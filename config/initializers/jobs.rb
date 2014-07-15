require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1d' do
  EventType.load
end

scheduler.every '1h' do
  horse_race = EventType.where("name like 'Horse%'").first
  greyhound_race = EventType.where("name like 'Horse%'").first
  Market.load horse_race.api_id
  Market.load greyhound_race.api_id if greyhound_race
end

scheduler.every '15m' do
  Market.update_closed_markets
end

scheduler.join
