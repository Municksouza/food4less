class FixCustomerForeignKeyInOrders < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :orders, column: :customer_id
    add_foreign_key :orders, :customers, column: :customer_id
  end
end