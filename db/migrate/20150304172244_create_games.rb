class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :region
      t.string :year
      t.timestamps
    end
  end
end
