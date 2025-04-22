class ChangeStatusToEnumInOrders < ActiveRecord::Migration[6.1]
  def change
    # Step 1: Add new integer column
    add_column :orders, :status_temp, :integer, default: 0

    # Step 2: Map existing string statuses to integers (optional safeguard)
    reversible do |dir|
      dir.up do
        Order.reset_column_information
        Order.find_each do |order|
          case order.status
          when "pending"
            order.update_column(:status_temp, 0)
          when "accepted"
            order.update_column(:status_temp, 1)
          when "rejected"
            order.update_column(:status_temp, 2)
          when "completed"
            order.update_column(:status_temp, 3)
          else
            order.update_column(:status_temp, 0)
          end
        end
      end
    end

    # Step 3: Remove old column and rename
    remove_column :orders, :status
    rename_column :orders, :status_temp, :status
  end
end