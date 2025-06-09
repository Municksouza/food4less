class AddProductToReviews < ActiveRecord::Migration[8.0]
  def change
    add_reference :reviews, :product, null: false, foreign_key: true
  end
end
