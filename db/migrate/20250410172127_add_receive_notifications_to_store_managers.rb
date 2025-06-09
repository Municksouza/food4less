class AddReceiveNotificationsToStoreManagers < ActiveRecord::Migration[8.0]
  def change
    add_column :store_managers, :receive_notifications, :boolean, default: false, null: false

    change_column_default :store_managers, :receive_notifications, from: nil, to: false
    change_column_null    :store_managers, :receive_notifications, false, false
  end
end
