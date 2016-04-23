class ChangeCityCodeToId < ActiveRecord::Migration
  def change
    rename_column :airports, :citycode, :city_id
    change_column :airports, :city_id, :integer
  end
end
