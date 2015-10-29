class AddCapacityToFare < ActiveRecord::Migration
  def change
  	add_column :fares, :capacity, :json
  end
end
