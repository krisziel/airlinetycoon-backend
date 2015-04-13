class CreateActualConfigurations < ActiveRecord::Migration
  def change
    create_table :actual_configurations do |t|
    	t.string :carrier
    	t.string :iata
    	t.string :name
    	t.json :config
      t.timestamps
    end
  end
end
