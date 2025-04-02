class RemoveLogoFromStores < ActiveRecord::Migration[8.0]
  def change
    remove_column :stores, :logo, :string
  end
end
