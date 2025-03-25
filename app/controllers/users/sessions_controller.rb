# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  def after_sign_in_path_for(resource)
    dashboard_path # ou outra rota que faça sentido no seu app
  end
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_by(email: params[:user][:email])

    if user
      case user.role
      when "customer"
        sign_in(:customer, user)
      when "business_admin"
        sign_in(:business_admin, user)
      when "store_manager"
        sign_in(:store_manager, user)
      else
        flash[:alert] = "Invalid role."
        redirect_to new_user_session_path and return
      end

      redirect_to after_sign_in_path_for(user)
    else
      flash[:alert] = "Invalid email or password."
      redirect_to new_user_session_path
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_in_path_for(resource)
    case resource
    when Customer
      customer_dashboard_path
    when BusinessAdmin
      business_dashboard_path
    when StoreManager
      store_dashboard_path
    else
      root_path
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
