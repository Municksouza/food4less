class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :store, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: { to_table: :customers }
      t.string :status
      t.decimal :total_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end