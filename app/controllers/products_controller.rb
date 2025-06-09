class ProductsController < ApplicationController
  def index
    if params[:category].present?
      @products = Product.where(category: params[:category])
    else
      @products = Product.all
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def category
    @category_name = params[:category_name]
    @products = Product.where(category: @category_name)

    render :category 
  end
end