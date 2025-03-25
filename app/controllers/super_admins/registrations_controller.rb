class SuperAdmins::RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_super_admin!, only: [:new, :create]
    before_action :configure_permitted_parameters, only: [:create]
  
    def new
      @super_admin = SuperAdmin.new
      super
    end
  
    def create
      @super_admin = SuperAdmin.new(super_admin_params)
  
      if @super_admin.save
        sign_in(@super_admin)
        redirect_to super_admin_dashboard_path, notice: "Super Admin successfully created."
      else
        render :new
      end
    end
  
    private
  
    def super_admin_params
      params.require(:super_admin).permit(:name, :email, :password, :password_confirmation, :phone)
    end
end