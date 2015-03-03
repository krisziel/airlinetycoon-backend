class CreateAlliances < ActiveRecord::Migration
  def change
    create_table :alliances do |t|
      t.string :name
      t.integer :game_id
      t.timestamps
    end
  end
end
