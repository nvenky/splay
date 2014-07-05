class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events, {id: false, primary_key: :api_id} do |t|
      t.primary_key :api_id
      t.string :name
      t.belongs_to :venue
      t.belongs_to :event_type
    end
    add_foreign_key(:events, :venues)
    add_foreign_key(:events, :event_types, primary_key: :api_id)
  end
end
