class AddFinalizedAtToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :finalized_at, :datetime
  end
end
