class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.decimal :old_price
      t.integer :stock
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
