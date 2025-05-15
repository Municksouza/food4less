# app/controllers/stores/products_controller.rb
module Stores
  class ProductsController < ApplicationController
    unless Rails.env.test?
      before_action :authenticate_store_manager!
      before_action :authenticate_business_admin_or_store_manager!
    end

    before_action :set_store
    before_action :set_product, only: [:show, :edit, :update, :destroy]


    def index
      @products = @store.products
    end

    def show; end

  def new
    @product = @store.products.new
  end

  def create
    @product = @store.products.new(product_params)
    if @product.save
      redirect_to stores_products_path, notice: "Product created"
    else
      puts @product.errors.full_messages # add this temporarily
      render :new
    end
  end

    def edit; end

    def update
      if @product.update(product_params)
        redirect_to stores_products_path, notice: 'Product successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @product.destroy
      redirect_to stores_products_path, notice: 'Product successfully removed.'
    end

    def manage
      @products = current_store_manager.store.products
    end

    def restore
      @product.update(active: true)
      redirect_to stores_products_path, notice: 'Product restored successfully.'
    end

    private

    def set_product
      @product = @store.products.find_by(id: params[:id])
      redirect_to stores_products_path, alert: 'Product not found.' unless @product
    end

    def set_store
      if current_store_manager
        @store = current_store_manager.store
      elsif current_business_admin
        @store = current_business_admin.stores.find_by(id: params[:store_id])
      else
        redirect_to root_path, alert: "Unauthorized access."
      end
    end 

    def product_params
      params.require(:product).permit(:name, :description, :original_price, :discount_price, :category_id, :stock, images: [])
    end

    def authenticate_business_admin_or_store_manager!
      unless business_admin_signed_in?
        redirect_to root_path, alert: "You need to be logged in to access this area."
      end
    end
  end
end