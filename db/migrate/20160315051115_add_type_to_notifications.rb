class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notificationable_type, :string
    add_column :notifications, :notificationable_id, :integer
    add_column :notifications, :header, :string
  end
end
