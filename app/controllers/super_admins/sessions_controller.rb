class SuperAdmins::SessionsController < Devise::SessionsController
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    def create
      super
    end
  
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    end
end