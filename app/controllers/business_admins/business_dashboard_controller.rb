class BusinessAdmins::BusinessDashboardController < ApplicationController
 
    before_action :authenticate_business_admin!
    before_action :ensure_business_admin!

    def show
      @sidebar_type = :business_admin

      @stores = current_business_admin.stores
      store_ids = @stores.pluck(:id)
    
      selected_store_id = params[:store_id].presence
      @selected_store = @stores.find_by(id: selected_store_id) if selected_store_id.present?
    
      filtered_store_ids = @selected_store ? [@selected_store.id] : store_ids
      @orders = Order.where(store_id: filtered_store_ids)
    
      @total_sales = @orders.where(status: 'accepted').sum(:total_amount) rescue 0
      @accepted_orders = @orders.where(status: 'accepted').count
      @rejected_orders = @orders.where(status: 'rejected').count
    
      order_ids = @orders.pluck(:id)
      @total_refunds = Refund.where(order_id: order_ids).sum(:amount)
      @customer_receipts = Receipt.where(receipt_type: 'customer', order_id: order_ids)
      @store_receipts = Receipt.where(receipt_type: 'store', store_id: filtered_store_ids)
      @customers = Customer.joins(:orders).where(orders: { store_id: filtered_store_ids }).distinct
    
      @sales_by_store = @stores.map { |store| [store.name, store.orders.sum(:total_price)] }.to_h
      @refunds_by_store = @stores.map { |store| [store.name, store.refunds.sum(:amount)] }.to_h
      @top_products = Product.joins(:order_items)
                             .where(store_id: filtered_store_ids)
                             .group(:name)
                             .order('SUM(order_items.quantity) DESC')
                             .limit(5)
                             .sum('order_items.quantity')
    
      group_by = params[:group_by] || 'day'
      @sales_over_time = @orders
                            .where(status: 'accepted')
                            .group_by_day(:created_at)
                            .sum(:total_price)
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
