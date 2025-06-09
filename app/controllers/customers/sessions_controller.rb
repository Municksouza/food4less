class Customers::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def after_sign_in_path_for(resource)
    customers_dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end