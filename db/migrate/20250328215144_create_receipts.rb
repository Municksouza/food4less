class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.string :receipt_type, null: false
      t.text :content, null: false
      t.references :order, foreign_key: true
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end