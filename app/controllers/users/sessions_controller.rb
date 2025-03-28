# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  
  # def create
  #   user = User.find_by(email: params[:user][:email])

  #   if user&.valid_password?(params[:user][:password])
  #     sign_in(user)

  #     redirect_to after_sign_in_path_for(user)
  #   else
  #     flash[:alert] = "Invalid email or password."
  #     redirect_to new_user_session_path
  #   end
  # end


  # # DELETE /resource/sign_out
  # # def destroy
  # #   super
  # # end

  # protected

  # def after_sign_in_path_for(resource)
  #   if resource.is_a?(Customer)
  #     customer_dashboard_path
  #   elsif resource.is_a?(BusinessAdmin)
  #     business_dashboard_path
  #   elsif resource.is_a?(StoreManager)
  #     store_dashboard_path
  #   elsif resource.is_a?(SuperAdmin)
  #     super_admin_dashboard_path
  #   else
  #     root_path
  #   end
  # end
  
  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
