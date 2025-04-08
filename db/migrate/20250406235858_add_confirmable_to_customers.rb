class AddConfirmableToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_column :customers, :confirmation_token, :string
    add_column :customers, :confirmed_at, :datetime
    add_column :customers, :confirmation_sent_at, :datetime
    add_column :customers, :unconfirmed_email, :string # Only if using reconfirmable
    add_index  :customers, :confirmation_token, unique: true
  end
end
