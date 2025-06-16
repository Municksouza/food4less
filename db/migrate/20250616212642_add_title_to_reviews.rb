class AddTitleToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :title, :string
  end
end
