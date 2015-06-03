class CreateRouteJumper < ActiveRecord::Migration
  def change
    create_table :route_jumpers do |t|
    	t.integer :origin_id
    	t.integer :destination_id
    	t.integer :distance
    	t.json :minfare
    	t.json :maxfare
    	t.json :price
    	t.json :demand
    	t.json :elasticity
    end
  end
end