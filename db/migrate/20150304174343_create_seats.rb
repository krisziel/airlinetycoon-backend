class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.string :name
      t.string :service_class
      t.float :sqft
      t.integer :price
      t.integer :rating
      t.timestamps
    end
  end
end
