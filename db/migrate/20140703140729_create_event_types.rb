class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types, {id: false, primary_key: :api_id} do |t|
      t.primary_key :api_id
      t.string :name
    end
  end
end
