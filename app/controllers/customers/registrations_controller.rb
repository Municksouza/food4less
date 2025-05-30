class Customers::RegistrationsController < Devise::RegistrationsController
  before_action :logout_if_authenticated, only: [:new]
  before_action :configure_permitted_parameters, only: [:create]

  def create
    build_resource(sign_up_params)

    if resource.save
      flash[:notice] = "Registration successful!"
      sign_up(resource_name, resource) # Uses Devise's method for proper authentication
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def logout_if_authenticated
    if customer_signed_in? # Checks if a Customer is logged in before logging out
      sign_out(current_customer)
      reset_session
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone])
  end

  def after_sign_up_path_for(resource)
    customers_dashboard_path
  end
end