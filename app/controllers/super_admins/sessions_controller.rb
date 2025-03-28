class SuperAdmins::SessionsController < Devise::SessionsController
    before_action :configure_permitted_parameters, if: :devise_controller?
  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      flash[:notice] = "Welcome back, #{resource.name}!"
      sign_in(:super_admin, resource)
      redirect_to after_sign_in_path_for(resource)
    else
      flash[:alert] = "Invalid email or password."
      redirect_to new_super_admin_session_path
    end
  end

  def destroy
    super
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end