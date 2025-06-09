# app/controllers/business_admins/business_store_dashboard_controller.rb
class BusinessAdmins::BusinessStoreDashboardController < ApplicationController
  before_action :authenticate_business_admin!
  before_action :set_store

  def show
    @store = current_business_admin.stores.friendly.find(params[:slug])    
    @orders = @store.orders
    @total_sales = @orders.where(status: 'accepted').sum(:total_amount)
    @accepted_orders = @orders.where(status: 'accepted').count
    @rejected_orders = @orders.where(status: 'rejected').count

    order_ids = @orders.pluck(:id)
    @total_refunds = Refund.where(order_id: order_ids).sum(:amount)
    @payments = Payment.where(order_id: order_ids)
    @customer_receipts = Receipt.where(receipt_type: 'customer', order_id: order_ids)
    @store_receipts = Receipt.where(receipt_type: 'store', store_id: @store.id)
    @customers = @store.customers.distinct

    # Here, you can also prepare data to manage products:
    @products = @store.products
  end

  private
  def set_store
    @store = current_business_admin.stores.friendly.find(params[:slug])  
  rescue ActiveRecord::RecordNotFound
    redirect_to business_admins_stores_path, alert: "Store not found or does not belong to you."
  end
end