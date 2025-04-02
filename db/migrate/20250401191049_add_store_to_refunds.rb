class AddStoreToRefunds < ActiveRecord::Migration[8.0]
  def change
    add_reference :refunds, :store, null: false, foreign_key: true
  end
end
