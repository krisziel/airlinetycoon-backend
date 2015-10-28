class CreateFlightLoads < ActiveRecord::Migration
  def change
    create_table :flight_loads do |t|
      t.integer :fare_routing_id
      t.integer :route_id
      t.json :revenue
      t.json :passengers
    end
  end
end
