class AddUniqueIndexToOrdersId < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!  # enable concurrent index creation

  def change
    unless index_exists?(:orders, :id, unique: true, name: 'unique_orders_id')
      remove_index(:orders, :id) if index_exists?(:orders, :id)
      add_index :orders, :id, unique: true, name: 'unique_orders_id', algorithm: :concurrently
    end
  end
end