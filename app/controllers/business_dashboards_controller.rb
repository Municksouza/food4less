class BusinessDashboardsController < ApplicationController
  before_action :authenticate_business_admin!
  before_action :ensure_business_admin!

  def show
    logger.debug "BusinessAdmin logged in: #{current_business_admin.inspect}"
    # @businesses = Business.where(business_admin_id: current_business_admin.id)    
    @stores = current_business_admin.stores
  end

  private

  def ensure_business_admin!
    redirect_to root_path, alert: "Acesso não autorizado" unless current_business_admin
  end
end