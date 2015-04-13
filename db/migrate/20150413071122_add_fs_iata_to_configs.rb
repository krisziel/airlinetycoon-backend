class AddFsIataToConfigs < ActiveRecord::Migration
  def change
  	add_column :actual_flights, :iata, :string
  end
end
