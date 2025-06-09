# app/controllers/business_admins/sessions_controller.rb
class BusinessAdmins::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  protected

  def after_sign_in_path_for(resource)
    business_admins_business_dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end