class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.string :name
      t.string :class
      t.float :sqft
      t.integer :rating
      t.integer :price
      t.timestamps
    end
  end
end
