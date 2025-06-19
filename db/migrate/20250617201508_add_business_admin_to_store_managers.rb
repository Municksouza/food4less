class AddBusinessAdminToStoreManagers < ActiveRecord::Migration[8.0]
  def change
    add_reference :store_managers, :business_admin, null: false, foreign_key: true
  end
end
