class AddNotificationInfoToAirline < ActiveRecord::Migration
  def change
  	add_column :airlines, :last_login, :timestamp
  	add_column :airlines, :last_update, :timestamp
  end
end
