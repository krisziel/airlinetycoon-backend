class CreateUserAircrafts < ActiveRecord::Migration
  def change
    create_table :user_aircrafts do |t|
      t.integer :aircraft_id
      t.integer :airline_id
      t.integer :aircraft_configuration_id
      t.integer :age
      t.boolean :inuse
      t.timestamps
    end
  end
end
