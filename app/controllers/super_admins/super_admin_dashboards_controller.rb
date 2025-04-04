module SuperAdmins
  class SuperAdminDashboardsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_super_admin!

    def show
      @users = User.all
      @businesses = Business.all
      @stores = Store.all
      @orders = Order.all
      @payments = Payment.all
    end

    private

    def ensure_super_admin!
      redirect_to root_path, alert: "Acesso não autorizado" unless current_user.super_admin?
    end
  end
end