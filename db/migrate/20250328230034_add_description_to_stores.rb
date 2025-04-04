class AddDescriptionToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :description, :text
  end
end
