module Shared
  class StoresBaseController < ApplicationController
    before_action :set_store
  
    def show
      @products = @store.products
      @reviews = @store.reviews.includes(:customer).order(created_at: :desc)
    end
  
    def edit; end
  
    def update
      if @store.update(store_params)
        redirect_to after_update_path, notice: "Store successfully updated.", allow_other_host: true
      else
        flash.now[:alert] = "Error updating the store."
        render :edit
      end
    end
  
    private
  
    def store_params
      params.require(:store).permit(:name, :email, :phone, :address, :zip_code, :description, :logo, :latitude, :longitude)
    end
  
    # Each controller defines how to find its store and which path to use
    def after_update_path
      raise NotImplementedError
    end
  
    def set_store
      raise NotImplementedError
    end
  end
end