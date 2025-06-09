class StoresController < ApplicationController
  
  def index
    @stores = Store.where(status: "active").where.not(latitude: nil, longitude: nil).order(:name)
  end

  before_action :set_store, only: [:show, :search_products]

  def show
    @reviews = @store.reviews
    @products = if params[:query].present?
                  @store.products.where("name ILIKE ?", "%#{params[:query]}%")
                else
                  @store.products
                end

    @show_search_modal = params[:query].present?
    @show_no_results_modal = params[:query].present? && @products.empty?
  end

  def search_products
    @products = @store.products.where("name ILIKE ?", "%#{params[:query]}%")
    @show_search_modal = @products.any?
    @show_no_results_modal = @products.empty?

    render turbo_stream: turbo_stream.replace(
      "product_search_modal",
      partial: "stores/products/search_modal",
      locals: {
        products: @products,
        show_modal: @show_search_modal,
        query: params[:query]
      }
    )
  end

  private

  def set_store
    @store = Store.friendly.find(params[:slug])
  end
end