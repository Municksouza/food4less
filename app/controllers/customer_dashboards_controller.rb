class CustomerDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer!

  def show
    @orders = current_user.orders
  end

  private

  def ensure_customer!
    redirect_to root_path, alert: "Acesso não autorizado" unless current_user.customer?
  end
end