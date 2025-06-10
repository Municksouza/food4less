class AddNameToStoreManagers < ActiveRecord::Migration[8.0]
  def change
    add_column :store_managers, :name, :string
  end
end
