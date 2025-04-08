class AddAmountToReceipts < ActiveRecord::Migration[8.0]
  def change
    add_column :receipts, :amount, :decimal
  end
end
