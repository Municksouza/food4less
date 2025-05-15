class StoresController < ApplicationController
  # rota pública: lista todas as lojas
  def index
    @stores = Store.where(status: "active").where.not(latitude: nil, longitude: nil).order(:name)
  end

  # rota pública: mostra detalhes de uma loja
  before_action :set_store, only: :show
  def show
    @store = Store.find(params[:id])
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
    @store = Store.find(params[:id])
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
    @store = Store.find(params[:id])
  end
end