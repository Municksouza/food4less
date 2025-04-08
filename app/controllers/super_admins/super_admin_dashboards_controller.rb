module SuperAdmins
  class SuperAdminDashboardsController < ApplicationController
    before_action :authenticate_super_admin!    
    before_action :ensure_super_admin!

    def show
      @users = User.all
      @business_admins = BusinessAdmin.all      
      @stores = Store.all
      @orders = Order.all
      @payments = Payment.all
    end

    private

    def ensure_super_admin!
      redirect_to root_path, alert: "Acesso não autorizado" unless current_super_admin
    end
  end
end