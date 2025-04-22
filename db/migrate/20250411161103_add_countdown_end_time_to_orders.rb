class AddCountdownEndTimeToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :countdown_end_time, :datetime
  end
end
