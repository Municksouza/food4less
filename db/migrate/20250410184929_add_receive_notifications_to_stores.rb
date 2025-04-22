class AddReceiveNotificationsToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :receive_notifications, :boolean, default: true, null: false  
  end
end
