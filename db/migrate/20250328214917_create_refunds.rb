class CreateRefunds < ActiveRecord::Migration[6.1]
  def change
    create_table :refunds do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.datetime :refund_date, null: false

      t.timestamps
    end
  end
end