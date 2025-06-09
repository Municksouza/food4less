class AddIssuedAtToReceipts < ActiveRecord::Migration[8.0]
  def change
    add_column :receipts, :issued_at, :datetime
  end
end
