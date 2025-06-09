module StoreManagersArea
    class StoresController < ApplicationController
      before_action :authenticate_store_manager!
      before_action :set_store, only: [:show, :edit, :update, :destroy]

      def index
        @stores = Store.where(status: "active").where.not(latitude: nil, longitude: nil)
      end
  
      def new
        @store = Store.new
      end
    
      def show
        @products = @store.products
        @reviews = @store.reviews.includes(:customer).order(created_at: :desc)
      end

      def create
        
      end

      def edit
        @products = @store.products
        @reviews = @store.reviews.includes(:customer).order(created_at: :desc)
      end

      def update
        if @store.update(store_params)
          redirect_to after_update_path, notice: "Store profile successfully updated."
        else
          flash.now[:alert] = "Error updating the store's details."
          render :edit
        end
      end
      
      def destroy
        if @store.destroy
          flash[:notice] = "Store successfully deleted."    
        else
          flash[:alert] = "Error deleting the store."
        end
      end
     
      private
  
      def set_store
        @store = current_store_manager.store
        if @store.slug != params[:slug]
          redirect_to root_path, alert: "Unauthorized access to store."
        end
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
          :website,
          :business_number,
          :cuisine_id, 
          :category_id,
          :receive_notifications,
          :status
        )
      end
      def authenticate_store_manager!
        unless store_manager_signed_in?
          redirect_to new_store_manager_session_path, alert: "You must be signed in as a Store Manager to access this page."
        end
      end
    end
end