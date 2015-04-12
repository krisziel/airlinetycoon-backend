class AddCapacityToActualFlight < ActiveRecord::Migration
  def change
  	add_column :actual_flights, :capacity, :integer
  end
end
