# app/controllers/business_admins/products_controller.rb
module BusinessAdmins
    class ProductsController < ApplicationController
      before_action :authenticate_business_admin!
      before_action :set_store
  
      def index
        @products = @store.products
      end
  
      def new
        @product = @store.products.build
      end
  
      def create
        @product = @store.products.build(product_params)
        if @product.save
          redirect_to business_admins_store_products_path(@store), notice: "Product created successfully!"
        else
          render :new
        end
      end
  
      def edit
        @product = @store.products.find(params[:id])
      end
  
      def update
        @product = @store.products.find(params[:id])
        if @product.update(product_params)
          redirect_to business_admins_store_products_path(@store), notice: "Product updated successfully!"
        else
          render :edit
        end
      end
  
      def destroy
        @product = @store.products.find(params[:id])
        @product.destroy
        redirect_to business_admins_store_products_path(@store), notice: "Product deleted."
      end
  
      private
  
      def set_store
        @store = current_business_admin.stores.find(params[:store_id])
      end
  
      def product_params
        params.require(:product).permit(:name, :description, :price, :old_price, :stock, images: [])
      end
    end
end