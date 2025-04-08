# app/controllers/business_admins/products_controller.rb
module BusinessAdmins
    class ProductsController < ApplicationController
      before_action :authenticate_business_admin!
      before_action :set_store
      before_action :set_product, only: [:edit, :update, :destroy, :restore]
  
      def index
        @store = Store.find(params[:store_id])
        @products = @store.products.where(active: true)
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
        @product.update(active: false)
        redirect_to business_admins_store_products_path(@store), notice: "Product archived successfully."
      end

      def restore
        @product.update(active: true)
        redirect_to business_admins_store_products_path(@store), notice: "Product restored successfully."
      end
      
      private
  
      def set_store
        @store = current_business_admin.stores.find(params[:store_id])
      end
  
      def product_params
        params.require(:product).permit(:name, :description, :price, :old_price, :stock, images: [])
      end

      def set_product
        @product = @store.products.find_by(id: params[:id])
        redirect_to business_admins_store_products_path(@store), alert: "Product not found." unless @product
      end
    end
end