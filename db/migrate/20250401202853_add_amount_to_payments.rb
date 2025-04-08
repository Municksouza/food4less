class AddAmountToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :amount, :decimal
  end
end
