class CreateTenQs < ActiveRecord::Migration
  def change
    create_table :ten_qs do |t|
      t.integer :airline_id
      t.string :period
      t.timestamps
    end
  end
end
