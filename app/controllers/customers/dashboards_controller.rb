module Customers
  class CustomerDashboardsController < ApplicationController  before_action :ensure_customer!

    def show
      @orders = current_customer.orders
    end

    private

    def ensure_customer!
      redirect_to root_path, alert: "Acesso não autorizado" unless current_customer
    end
  end
end