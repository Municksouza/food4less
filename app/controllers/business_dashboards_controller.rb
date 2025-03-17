class BusinessDashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_business_admin!

  def show
    @businesses = Business.where(user: current_user)
    @stores = Store.where(business: @businesses)
  end

  private

  def ensure_business_admin!
    redirect_to root_path, alert: "Acesso não autorizado" unless current_user.business_admin?
  end
end