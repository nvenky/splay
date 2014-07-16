require 'csv'
class AddStateClassTierToVenue < ActiveRecord::Migration
  def up
    add_column :venues, :territory, :string
    add_column :venues, :venue_class, :string
    add_column :venues, :tier, :integer

    update_existing_records
  end

  def down
    remove_column :venues, :territory
    remove_column :venues, :venue_class
    remove_column :venues, :tier
  end

  private
  def update_existing_records
    csv_text = File.read("#{Rails.root}/db/seed/venues.dump")
    venues = CSV.parse(csv_text, :headers => true)
    venues.each do |row|
      values = row.to_hash
      v = Venue.where(['name like ? ', values['Name']]).first_or_create
      v.name = values['Name']
      v.territory = values['Territory']
      v.venue_class = values['Class']
      v.country_code = values['Country Code']
      v.tier = values['Tier']
      v.save!
    end
  end
end
