class CreateSuperAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :super_admins do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest

      t.timestamps
    end
  end
end
