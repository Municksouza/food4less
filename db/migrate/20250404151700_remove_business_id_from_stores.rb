class RemoveBusinessIdFromStores < ActiveRecord::Migration[7.0]
  def change
    remove_column :stores, :business_id, :bigint
  end
end