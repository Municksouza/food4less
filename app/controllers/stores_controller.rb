class StoresController < ApplicationController
  # before_action :authenticate_business_admin!
  # before_action :set_store, only: [:edit, :update, :destroy]

  # def new
  #   @store = Store.new
  # end

  # def show
  #   @store = Store.find(params[:id])
  #   @products = @store.products
  #   @reviews = @store.reviews.includes(:customer).order(created_at: :desc)
  # end

  # def create
  #   @store = current_business_admin.stores.build(store_params)
  #   password = params[:store_manager_password]
  #   password_confirmation = params[:store_manager_password_confirmation]
    
  #   # Creates the Store Manager account for the new store
  #   store_manager = StoreManager.new(
  #     email: @store.email,
  #     password: password,
  #     password_confirmation: password_confirmation,
  #     store: @store
  #   )
  #   # If there is an association between StoreManager and Store, assign: store_manager.store = @store

  #   if @store.save && store_manager.save
  #     # Sends the credentials to the email provided in the form
  #     recipient_email = params[:store_manager_recipient_email].presence || @store.email
  #     StoreMailer.send_credentials(@store, store_manager, password, recipient_email).deliver_now
  #     flash[:notice] = "Store successfully created. Credentials have been sent to #{recipient_email}."
  #     redirect_to business_dashboard_path
  #   else
  #     flash.now[:alert] = "Error creating the store or the manager."
  #     render :new
  #   end
  # end

  # def edit
  #   # Displays the form to edit the store's details
  # end

  # def update
  #   if @store.update(store_params)
  #     redirect_to store_admin_dashboard_path(@store), notice: "Store profile successfully updated."
  #   else
  #     flash.now[:alert] = "Error updating the store's details."
  #     render :edit
  #   end
  # end

  # def destroy
  #   @store = current_business_admin.stores.find(params[:id])
  #   if @store.destroy
  #     flash[:notice] = "Store successfully deleted."
  #   else
  #     flash[:alert] = "Error deleting the store."
  #   end
  #   redirect_to business_dashboard_path
  # end

  # private

  # def set_store
  #   @store = current_business_admin.stores.find(params[:id])
  # end

  # def store_params
  #   params.require(:store).permit(:name, :email, :phone, :address, :zip_code, :description, :logo, :latitude, :longitude)
  # end

  def index
    @stores = Store.all
  end

  def show
    @store = Store.find(params[:id])
    @products = @store.products
    @reviews = @store.reviews.includes(:customer).order(created_at: :desc)
  end

  private

  def store_params
    params.require(:store).permit(:name, :email, :phone, :address, :zip_code, :description, :logo, :latitude, :longitude)
  end
end
