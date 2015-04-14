class CreateActualFares < ActiveRecord::Migration
  def change
    create_table :actual_fares do |t|
    	t.string :origin
    	t.string :destination
    	t.integer :fare
    end
  end
end
