class AddTimeCycleToGames < ActiveRecord::Migration
  def change
    add_column :games, :next_turn, :timestamp
  end
end
