class AddPaymentDateToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :payment_date, :datetime
  end
end
