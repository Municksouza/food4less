class AddNoteToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :note, :text
  end
end
