class StoresController < ApplicationController
  before_action :authenticate_business_admin!

  def new
    @store = Store.new
  end

  def create
    @store = current_business_admin.stores.build(store_params)
    generated_password = Devise.friendly_token.first(8) # Gerar senha aleatória

    store_manager = StoreManager.create!(
      email: @store.email,
      password: generated_password,
      password_confirmation: generated_password
    )

    if @store.save
      StoreMailer.send_credentials(@store, store_manager, generated_password).deliver_now
      redirect_to business_dashboard_path, notice: "Store created successfully. Credentials sent to Store Manager."
    else
      render :new
    end
  end

  private

  def store_params
    params.require(:store).permit(:name, :email, :phone, :address, :zip_code, :logo)
  end
end