class CreateBusinesses < ActiveRecord::Migration[8.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :zip_code
      t.string :logo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
