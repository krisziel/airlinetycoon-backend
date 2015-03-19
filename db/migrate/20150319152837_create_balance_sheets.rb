class CreateBalanceSheets < ActiveRecord::Migration
  def change
    create_table :balance_sheets do |t|
      t.integer :cash_assets
      t.integer :fuel_assets
      t.integer :current_assets
      t.integer :aircraft_assets
      t.integer :total_assets
      t.integer :long_term_debt
      t.timestamps
    end
  end
end
