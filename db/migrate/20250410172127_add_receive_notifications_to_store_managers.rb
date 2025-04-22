class AddReceiveNotificationsToStoreManagers < ActiveRecord::Migration[8.0]
  def change
    add_column :store_managers, :receive_notifications, :boolean
  end
end
