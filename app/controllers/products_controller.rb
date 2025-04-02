class ProductsController < ApplicationController
  before_action :authenticate_store_manager!
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = current_store_manager.store.products
  end

  def show
  end

  def new
    @product = current_store_manager.store.products.build
  end

  def create
    @product = current_store_manager.store.products.build(product_params)
    if @product.save
      redirect_to products_path, notice: 'Product successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: 'Product successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Product successfully removed.'
  end

  def manage
    @products = current_store_manager.store.products
  end

  private

  def set_product
    @product = current_store_manager.store.products.find_by(id: params[:id])
    unless @product
      redirect_to products_path, alert: 'Product not found.'
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :original_price, :discount_price, :stock, images: [])
  end
end