class CreateGameChats < ActiveRecord::Migration
  def change
    create_table :game_chats do |t|
      t.integer :game_id
      t.integer :airline_id
      t.text :message
      t.timestamps
    end
  end
end
