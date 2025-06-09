class AddReceiveNotificationsToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :receive_notifications, :boolean, default: true, null: false 
    change_column_default :stores, :receive_notifications, from: nil, to: false
    change_column_null    :stores, :receive_notifications, false, false 
  end
end
