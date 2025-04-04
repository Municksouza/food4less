class AddStoreToStoreManagers < ActiveRecord::Migration[8.0]
  def change
    add_reference :store_managers, :store, foreign_key: true, null: true
  end
end
