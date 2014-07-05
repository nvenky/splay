class CreateMarketRunners < ActiveRecord::Migration
  def change
    create_table :market_runners do |t|
      t.belongs_to :market, index: true
      t.belongs_to :runner, index: true
      t.decimal :actual_sp
      t.string :status
    end
  end
end
