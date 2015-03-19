class CreateIncomeStatements < ActiveRecord::Migration
  def change
    create_table :income_statements do |t|
      t.integer :total_revenue
      t.integer :passenger_revenue
      t.integer :cargo_revenue
      t.integer :total_cost
      t.integer :fuel_cost
      t.integer :salaries
      t.integer :aircraft_cost
      t.integer :special_cost
      t.integer :operating_income
      t.integer :interest_expense
      t.integer :pre_tax_income
      t.integer :net_income
      t.timestamps
    end
  end
end
