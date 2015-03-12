class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :airline_id
      t.integer :route_id
      t.integer :user_aircraft_id
      t.integer :duration
      t.integer :frequencies
      t.json :fare
      t.json :passengers
      t.json :revenue
      t.json :load
      t.integer :cost
      t.integer :profit
      t.timestamps
    end
  end
end
