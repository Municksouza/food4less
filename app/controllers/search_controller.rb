class SearchController < ApplicationController
  def index
    query = params[:query].to_s.strip
    @store_results = Store.where("name ILIKE ?", "%#{query}%")
    @product_results = Product.where("name ILIKE ?", "%#{query}%")
  end
end