class CreateFares < ActiveRecord::Migration
  def change
    create_table :fares do |t|
      t.integer :airline_id
      t.integer :route_id
      t.json :fare
      t.json :passengers
      t.json :revenue
      t.json :routing
      t.timestamps
    end
  end
end
