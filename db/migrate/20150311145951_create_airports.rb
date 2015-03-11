class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :iata, limit: 3
      t.string :icao, limit: 4
      t.string :citycode, limit: 3
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.integer :population
      t.integer :slots_total
      t.integer :slots_available
      t.string :latitude
      t.string :longitude
      t.string :business_demand
      t.string :leisure_demand
      t.string :region
      t.string :country_code
      t.integer :display_year
      t.timestamps
    end
  end
end
