class AddDefaultToReceiveNotifications < ActiveRecord::Migration[6.0]
  def change
    change_column_default :stores, :receive_notifications, from: nil, to: false
    Store.where(receive_notifications: nil).update_all(receive_notifications: false)
  end
end