class CreateAircraftConfigurations < ActiveRecord::Migration
  def change
    create_table :aircraft_configurations do |t|
      t.string :name
      t.integer :aircraft_id
      t.integer :airline_id
      t.integer :f_count
      t.integer :j_count
      t.integer :p_count
      t.integer :y_count
      t.integer :f_seat
      t.integer :j_seat
      t.integer :p_seat
      t.integer :y_seat
      t.timestamps
    end
  end
end
