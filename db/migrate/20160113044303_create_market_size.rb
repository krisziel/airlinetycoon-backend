class CreateMarketSize < ActiveRecord::Migration
  def change
    create_table :market_sizes do |t|
      t.integer :flights
      t.integer :seats
      t.integer :asm
      t.integer :rpm
      t.integer :load_factor
      t.integer :airline_id
      t.integer :game_id
      t.references :marketable, polymorphic: true
      t.timestamps null: false
    end
  end
end
