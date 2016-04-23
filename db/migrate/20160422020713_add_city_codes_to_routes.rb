class AddMarketIdToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :market_id, :integer
  end
end
