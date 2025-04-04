class AddNameToBusinessAdmins < ActiveRecord::Migration[8.0]
  def change
    add_column :business_admins, :name, :string
  end
end
