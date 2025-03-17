class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :zip_code
      t.string :logo
      t.references :business, null: false, foreign_key: true
      t.string :manager_email

      t.timestamps
    end
  end
end
