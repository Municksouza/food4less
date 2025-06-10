class AddBusinessAdminIdToReceipts < ActiveRecord::Migration[8.0]
  def change
    add_reference :receipts, :business_admin, foreign_key: true, null: true
  end
end
