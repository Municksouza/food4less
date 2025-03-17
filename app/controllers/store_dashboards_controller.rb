class StoreDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_store_manager!

  def show
    @store = Store.find_by(manager_email: current_user.email)
    @products = @store.products
    @orders = @store.orders
  end

  private

  def ensure_store_manager!
    redirect_to root_path, alert: "Acesso não autorizado" unless current_user.store_manager?
  end
end