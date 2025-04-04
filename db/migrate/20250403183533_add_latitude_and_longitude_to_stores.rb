class AddLatitudeAndLongitudeToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :latitude, :float
    add_column :stores, :longitude, :float
  end
end
