class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: -> { controller_name == "pages" && action_name == "home" }
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_turbo_headers
  before_action :allow_iframe_requests



  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :phone])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def after_sign_in_path_for(resource)
    case resource
    when SuperAdmin
      super_admin_dashboard_path
    when BusinessAdmin
      business_dashboard_path
    when StoreManager
      store_dashboard_path
    when Customer
      customer_dashboard_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource) # Usa o mesmo redirecionamento do login
  end

  def set_turbo_headers
    response.set_header("Turbo-Frame", "true")
  end

  def allow_iframe_requests
    response.headers.delete("X-Frame-Options")
  end
end
