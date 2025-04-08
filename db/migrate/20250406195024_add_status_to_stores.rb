class AddStatusToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :status, :string
  end
end