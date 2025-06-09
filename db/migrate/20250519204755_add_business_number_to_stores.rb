class AddBusinessNumberToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :business_number, :string, null: false, default: ""
    add_index  :stores, :business_number, unique: true
  end
end
