class ProductsController < ApplicationController
  before_action :authenticate_business_admin_or_store_manager!  
  before_action :set_store
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = @store.products
  end

  def show
  end

  def new
    @product = @store.products.build
  end

  def create
    @product = @store.products.build(product_params)
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
    @product = @store.products.find_by(id: params[:id])
    redirect_to store_products_path(@store), alert: 'Product not found.' unless @product
  end

  def set_store
    if current_business_admin
      @store = current_business_admin.stores.find(params[:store_id])
    elsif current_store_manager
      @store = current_store_manager.store
    else
      redirect_to root_path, alert: "Unauthorized access."
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :original_price, :discount_price, :stock, images: [])
  end

  def authenticate_business_admin_or_store_manager!
    unless business_admin_signed_in? || store_manager_signed_in?
      redirect_to root_path, alert: "You need to be logged in to access this area."
    end
  end
end