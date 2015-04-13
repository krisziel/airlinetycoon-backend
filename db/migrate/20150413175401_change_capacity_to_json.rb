class ChangeCapacityToJson < ActiveRecord::Migration
  def change
  	change_column :actual_flights, :capacity, :string
  end
end
