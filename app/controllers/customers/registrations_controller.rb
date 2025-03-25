class Customers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]

  def new
    @customer = Customer.new
    super
  end

  def create
    @customer = Customer.new(sign_up_params)
    if @customer.save
      flash[:notice] = "Customer account created successfully!"
      redirect_to root_path
    else
      render :new
    end
  end
  
  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone])
  end
end