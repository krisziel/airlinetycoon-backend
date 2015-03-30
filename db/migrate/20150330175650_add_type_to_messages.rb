class AddTypeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :message_type, :string
    rename_column :messages, :conversation_id, :type_id
  end
end
