class AddReadyInMinutesToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :ready_in_minutes, :integer
  end
end
