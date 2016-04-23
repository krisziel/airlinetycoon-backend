class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.integer :origin_id
      t.integer :destination_id
      t.json :passengers
      t.json :fares
      t.json :elasticity
      t.json :adjustment
    end
  end
end
