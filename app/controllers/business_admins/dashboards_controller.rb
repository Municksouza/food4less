module BusinessAdmins
  class DashboardsController < ApplicationController  before_action :authenticate_business_admin!
    before_action :ensure_business_admin!

    def show
      @stores = current_business_admin.stores
      store_ids = @stores.pluck(:id)  # Defina store_ids primeiro

      @orders = Order.where(store_id: store_ids)
      begin
        @total_sales = @orders.where(status: 'accepted').sum(:total_amount)
      rescue => e
        Rails.logger.error "Erro ao calcular total_sales: #{e.message}"
        @total_sales = 0
      end
      @accepted_orders = @orders.where(status: 'accepted').count
      @rejected_orders = @orders.where(status: 'rejected').count

      order_ids = @orders.pluck(:id)
      @total_refunds = Refund.where(order_id: order_ids).sum(:amount)
      @customer_receipts = Receipt.where(receipt_type: 'customer', order_id: order_ids)
      @store_receipts = Receipt.where(receipt_type: 'store', store_id: store_ids)
      @customers = Customer.joins(:orders)
                          .where(orders: { store_id: store_ids })
                          .distinct
    end

    def financial
      @stores = current_business_admin.stores
      store_ids = @stores.pluck(:id)
      @orders = Order.where(store_id: store_ids)
      # Prepare dados detalhados financeiros, gráficos, etc.
    end

    def payments
      @stores = current_business_admin.stores
      store_ids = @stores.pluck(:id)
      @payments = Payment.where(store_id: store_ids)
    end

    def refunds
      @stores = current_business_admin.stores
      store_ids = @stores.pluck(:id)
      order_ids = Order.where(store_id: store_ids).pluck(:id)
      @refunds = Refund.where(order_id: order_ids)
    end

    def search_customers
      query = params[:query]
      store_ids = current_business_admin.stores.pluck(:id)
      @customers = Customer.joins(:orders)
                          .where(orders: { store_id: store_ids })
                          .where("customers.name ILIKE ?", "%#{query}%")
                          .distinct
      render :search_results
    end

    private
    
    def ensure_business_admin!
      redirect_to root_path, alert: "Acesso não autorizado" unless current_business_admin
    end
  end
end