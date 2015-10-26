class CreateFares < ActiveRecord::Migration
  def change
    create_table :fares do |t|
      t.integer :airline_id
      t.integer :route_id
      t.json :fare
      t.json :passengers
      t.json :revenue
      t.text :routings, array:true, default: []
      t.timestamps
    end
  end
end
