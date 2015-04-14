class CreateActualRoute < ActiveRecord::Migration
  def change
    create_table :actual_routes do |t|
    	t.integer :route_id
    	t.integer :origin_id
    	t.integer :destination_id
    	t.integer :flights
    	t.json :carriers
    	t.json :capacity
    	t.json :fares
    end
  end
end
