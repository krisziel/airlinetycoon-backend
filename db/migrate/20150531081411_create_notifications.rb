class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :flight_id
      t.integer :route_id
      t.string :text
      t.boolean :read
      t.timestamps
    end
  end
end
