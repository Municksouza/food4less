class AddActiveToStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :active, :boolean, default: true
  end
end