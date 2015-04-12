class CreateActualAircraft < ActiveRecord::Migration
  def change
    create_table :actual_aircrafts do |t|
    	t.string :iata
    	t.string :fs_iata
    	t.string :name
    	t.string :manufacturer
    	t.integer :capacity
    end
  end
end
