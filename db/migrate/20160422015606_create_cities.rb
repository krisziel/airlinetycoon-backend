class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :code
      t.json :business_demand
      t.json :leisure_demand
    end
  end
end
