class AddPreparationTimeToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :preparation_time, :integer
  end
end
