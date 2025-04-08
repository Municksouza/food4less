class BusinessAdmins::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      flash[:notice] = "Welcome back, #{resource.name}!"
      sign_in(:business_admin, resource)
      redirect_to after_sign_in_path_for(resource)
    else
      flash[:alert] = "Invalid email or password."
      redirect_to new_business_admin_session_path
    end
  end

  def destroy
    super
  end
end