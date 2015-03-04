class CreateAirlines < ActiveRecord::Migration
  def change
    create_table :airlines do |t|
      t.string :name, {:limit => 50, :null => false}
      t.string :icao, {:limit => 3, :null => false}
      t.integer :money, {:limit => 8}
      t.integer :game_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
end
