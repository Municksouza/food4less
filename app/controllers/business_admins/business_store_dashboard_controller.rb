# app/controllers/business_store_dashboards_controller.rb
class BusinessAdmins::BusinessStoreDashboardController < ApplicationController
  before_action :set_store

  def show
    @store = Store.find(params[:store_id])
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

    # Aqui, você também pode preparar dados para gerenciar produtos:
    @products = @store.products
  end

  private

  def set_store
    # O BusinessAdmin só pode acessar as lojas que lhe pertencem
    @store = current_business_admin.stores.find(params[:store_id])
  end
end