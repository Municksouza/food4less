class AddDeviseFieldsToSuperAdmins < ActiveRecord::Migration[8.0]
  def change
    change_table :super_admins do |t|
      t.string :encrypted_password, null: false, default: ""
    end
  end
end
