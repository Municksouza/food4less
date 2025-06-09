class AddCategoryToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :category_id, :integer
  end
end
