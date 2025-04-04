module BusinessAdmins
  class BusinessStoreManagerCredentialsController < ApplicationController
    before_action :authenticate_business_admin!
    before_action :set_store_and_manager
  
    def edit
      # Renders the form to edit credentials
    end
  
    def update
      if @store_manager.update(store_manager_params)
        redirect_to store_admin_dashboard_path(@store), notice: "Credentials successfully updated."
      else
        flash.now[:alert] = "Error updating credentials."
        render :edit
      end
    end
  
    private
  
    def set_store_and_manager
      # The BusinessAdmin can only edit stores that belong to them
      @store = current_business_admin.stores.find(params[:store_id])
      @store_manager = @store.store_manager
      unless @store_manager
        redirect_to business_admins_store_dashboard_path(@store), alert: "Store Manager not found for this store."
      end
    end
  
    def store_manager_params
      # Allows updating the email and, if provided, the password
      params.require(:store_manager).permit(:email, :password, :password_confirmation)
    end
  end
end