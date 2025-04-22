class AddFinancialFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :subtotal,         :decimal, precision: 10, scale: 2, default: "0.0", null: false
    add_column :orders, :taxes,            :decimal, precision: 10, scale: 2, default: "0.0", null: false
    add_column :orders, :total_with_taxes, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end