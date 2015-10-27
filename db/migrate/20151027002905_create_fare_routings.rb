class CreateFareRoutings < ActiveRecord::Migration
  def change
    create_table :fare_routings do |t|
      t.integer :fare_id
      t.json :market_fare
      t.json :capacity
      t.json :excess_capacity
      t.text :routing, array:true, default: []
    end
  end
end
