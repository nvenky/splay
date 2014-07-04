class CreateEventTypeTable < ActiveRecord::Migration
  def change
    create_table :event_types, {id: false, primary_key: :api_id} do |t|
      t.integer :api_id, :primary_key
      t.string :name
    end
    execute "ALTER TABLE event_types ADD PRIMARY KEY (api_id);"
  end
end
