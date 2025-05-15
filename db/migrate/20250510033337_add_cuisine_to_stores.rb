class AddCuisineToStores < ActiveRecord::Migration[8.0]
  def change
    add_reference :stores, :cuisine, null: true, foreign_key: true  
  end
end
