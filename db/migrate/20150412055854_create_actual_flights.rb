class CreateActualFlights < ActiveRecord::Migration
  def change
    create_table :actual_flights do |t|
			t.integer :origin_id
			t.integer :destination_id
			t.integer :duration
			t.string :equipment
			t.string :carrier
			t.integer :flight
      t.timestamps
    end
  end
end
