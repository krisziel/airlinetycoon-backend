class AddAirlineToNotification < ActiveRecord::Migration
  def change
  	add_column :notifications, :airline_id, :integer
  end
end
