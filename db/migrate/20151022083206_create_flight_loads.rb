class CreateFlightLoads < ActiveRecord::Migration
  def change
    create_table :flight_loads do |t|
      t.integer :airline_id
      t.integer :fare_id
      t.integer :flight_id
      t.json :revenue
      t.json :passengers
      t.timestamps
    end
  end
end
