class AddForeignKeyToStores < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :stores, :business_admins
  end
end