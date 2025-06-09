class AddOldPriceToProducts < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:products, :old_price)
      add_column :products, :old_price, :decimal, precision: 10, scale: 2
    end
  end
end
