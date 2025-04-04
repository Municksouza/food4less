class CreateOrderHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :order_histories do |t|
      t.string :status
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
