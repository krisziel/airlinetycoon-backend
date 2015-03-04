class CreateAircrafts < ActiveRecord::Migration
  def change
    create_table :aircrafts do |t|
      t.string :manufacturer
      t.string :name
      t.string :iata
      t.string :sqft
      t.string :capacity
      t.integer :price
      t.integer :range
      t.integer :speed
      t.integer :turn_time
      t.integer :fuel_capacity
      t.integer :fuel_burn
      t.float :discount
      t.timestamps
    end
  end
end
