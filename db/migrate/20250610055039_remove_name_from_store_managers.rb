class RemoveNameFromStoreManagers < ActiveRecord::Migration[8.0]
  def change
    remove_column :store_managers, :name, :string
  end
end
