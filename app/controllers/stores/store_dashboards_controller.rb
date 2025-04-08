module Stores
  class StoreDashboardsController < ApplicationController  
    before_action :authenticate_store_manager!
    before_action :set_store


    def show

      @store = current_store_manager.store
      @orders = @store.orders
      @total_sales = Order.where(store_id: @store.id).where(status: 'accepted').sum(:total_price)
      @accepted_orders = @orders.where(status: 'accepted').count
      @rejected_orders = @orders.where(status: 'rejected').count
      @products = @store.products
      @payments = @store.payments
      @receipts = @store.receipts
      @total_refunds = Refund.where(order_id: @orders.pluck(:id)).sum(:amount)
      @customers = @store.customers.distinct
      @total_payments = @store.payments.sum(:amount)    
      @total_receipts = @receipts.sum(:amount)
      order_ids = @orders.pluck(:id)

    end

    private

    def set_store
      @store = current_store_manager.store
    end
  end
end