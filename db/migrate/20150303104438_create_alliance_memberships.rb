class CreateAllianceMemberships < ActiveRecord::Migration
  def change
    create_table :alliance_memberships do |t|
      t.integer :airline_id
      t.integer :alliance_id
      t.boolean :status
      t.integer :position
      t.timestamps
    end
  end
end
