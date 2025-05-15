class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActionController::Redirecting::UnsafeRedirectError do
    if Rails.env.test?
      redirect_to root_url(host: "www.example.com", allow_other_host: true)
    else
      redirect_to root_url
    end
  end
  
  helper_method :current_customer, :customer_signed_in?
  helper_method :current_business_admin, :business_admin_signed_in?
  helper_method :current_store_manager, :store_manager_signed_in?
  helper_method :current_account

  def pundit_user
    current_account
  end

  def current_user_of_type(type, scope)
    user = warden.user(scope)
    return unless user.present? && user.is_a?(type)

    user
  end

  def current_customer
    current_user_of_type(Customer, :customer)
  end

  def customer_signed_in?
    current_customer.present?
  end

  def current_business_admin
    current_user_of_type(BusinessAdmin, :business_admin)
  end

  def business_admin_signed_in?
    current_business_admin.present?
  end

  def current_store_manager
    current_user_of_type(StoreManager, :store_manager)
  end

  def store_manager_signed_in?
    current_store_manager.present?
  end

  def current_account
    current_customer || current_business_admin || current_store_manager 
  end

  def after_sign_in_path_for(resource)
    case resource
    when Customer
      customers_dashboard_path
    when BusinessAdmin
      business_admins_business_dashboard_path
    when StoreManager
      stores_store_dashboard_path
    when Store
      store_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    flash[:success] = "Sign-up successful!"
    after_sign_in_path_for(resource)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :zip_code, issues_array: []])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  def user_not_authorized
    flash[:alert] = "You do not have permission to access this page."
    redirect_to(request.referer || root_path)
  end
end