class AddBusinessNumberToBusinessAdmins < ActiveRecord::Migration[8.0]
  def change
    add_column :business_admins, :business_number, :string, null: false, default: ""
    add_index  :business_admins, :business_number, unique: true
  end
end