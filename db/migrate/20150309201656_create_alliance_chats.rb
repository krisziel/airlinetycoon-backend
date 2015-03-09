class CreateAllianceChats < ActiveRecord::Migration
  def change
    create_table :alliance_chats do |t|
      t.integer :airline_id
      t.integer :alliance_id
      t.text :message
      t.timestamps
    end
  end
end
