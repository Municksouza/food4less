class AddDiscountPriceToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :discount_price, :decimal
  end
end
