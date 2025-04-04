class AddDetailsToBusinessAdmins < ActiveRecord::Migration[8.0]
  def change
    add_column :business_admins, :address, :string
    add_column :business_admins, :zip_code, :string
    add_column :business_admins, :phone, :string
    add_column :business_admins, :logo, :string
  end
end
