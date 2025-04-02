class FixStoresForeignKey < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :stores, :businesses

    add_foreign_key :stores, :business_admins, column: :business_id
  end
end