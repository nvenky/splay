class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners, {id: false, primary_key: :api_id} do |t|
      t.integer :api_id
      t.string :name
      t.string :market_id
    end
    execute "ALTER TABLE RUNNERS ADD PRIMARY KEY (api_id);"
    add_foreign_key(:runners, :markets, primary_key: :api_id)
  end
end
