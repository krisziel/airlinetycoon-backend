class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notificationable_type, :string
    add_column :notifications, :notificationable_id, :integer
  end
end
