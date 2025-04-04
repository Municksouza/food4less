class AddBusinessAdminIdToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :business_admin_id, :integer
  end
end
