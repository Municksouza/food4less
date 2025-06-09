class SearchController < ApplicationController
  def show
    @store = Store.find_by(id: params[:id])
    unless @store
      render plain: "Store not found", status: :not_found and return
    end

    if params[:query].present?
      @products = @store.products.where("name ILIKE ?", "%#{params[:query]}%")
      render partial: "stores/products/search_modal", formats: [:html]
    else
      @products = @store.products
    end

    @product_results = Product.where("name ILIKE ?", "%#{params[:query]}%") || []
    @store_results   = Store.where("name ILIKE ?", "%#{params[:query]}%") || []
    @cuisine_results = Cuisine.where("name ILIKE ?", "%#{params[:query]}%") || []

    @product_results = @product_results.to_a
    @store_results   = @store_results.to_a
    @cuisine_results = @cuisine_results.to_a
  end

  def index
    query = params[:query].to_s.strip

    @product_results = Product.where("name ILIKE ?", "%#{query}%")
    @store_results   = Store.where("name ILIKE ?", "%#{query}%")
    @cuisine_results = Cuisine.where("name ILIKE ?", "%#{query}%")

    # Fallback in case no results are found
    @product_results ||= []
    @store_results   ||= []
    @cuisine_results ||= []
  end
end