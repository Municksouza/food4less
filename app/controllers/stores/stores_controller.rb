module Stores
    class StoresController < ApplicationController
      before_action :authenticate_store_manager!

      def index
        @stores = Store.where(status: "active").where.not(latitude: nil, longitude: nil)
      end
  
      def new
        @store = Store.new
      end
    
      def show
        @store = Store.find(params[:id])
        @products = @store.products
        @reviews = @store.reviews.includes(:customer).order(created_at: :desc)
      end

      def create
        
      end

      def edit
        @store = Store.find(params[:id])
        @products = @store.products
        @reviews = @store.reviews.includes(:customer).order(created_at: :desc)
      end

      def update
        @store = Store.find(params[:id])
        if @store.update(store_params)
          redirect_to after_update_path, notice: "Store profile successfully updated."
        else
          flash.now[:alert] = "Error updating the store's details."
          render :edit
        end
      end
      
      def destroy
        @store = Store.find(params[:id])
        if @store.destroy
          flash[:notice] = "Store successfully deleted."    
        else
          flash[:alert] = "Error deleting the store."
        end
      end
     
      private
  
      def set_store
        @store = current_store_manager.store
      end
  
      def after_update_path
        stores_store_path(@store)
      end

      def store_params
        params.require(:store).permit(
          :name,
          :description,
          :address,
          :city,
          :state,
          :zip_code,
          :country,
          :phone_number,
          :email,
          :website
        )
      end
      def authenticate_store_manager!
        unless store_manager_signed_in?
          redirect_to new_store_manager_session_path, alert: "You must be signed in as a Store Manager to access this page."
        end
      end
    end
end