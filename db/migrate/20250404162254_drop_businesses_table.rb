class DropBusinessesTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :businesses
  end

  def down
    create_table :businesses do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end