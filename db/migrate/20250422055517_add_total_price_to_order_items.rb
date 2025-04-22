class AddTotalPriceToOrderItems < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :total_price, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end