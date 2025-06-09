module StoreManagersArea
  class StoreDashboardsController < ApplicationController
    layout "application"
    before_action :authenticate_store_manager!
    before_action :set_store

    def show  
      @sidebar_type = :store_manager
      @order = @store.orders.find_by(id: params[:order_id]) if params[:order_id].present?
      if params[:order_id].present? && @order.nil?
        Rails.logger.debug "Order not found for store: #{@store.id}, order_id: #{params[:order_id]}"
        flash[:alert] = "Order not found."
      end

      Rails.logger.debug "Store: #{@store.inspect}, Order: #{@order.inspect}"

      @pending_orders = @store.orders.pending.order(created_at: :desc)
      @accepted_orders = @store.orders.accepted.order(created_at: :desc)
      @completed_orders = @store.orders.completed.order(created_at: :desc)
      @rejected_orders = @store.orders.rejected.order(created_at: :desc)
      @in_progress_orders = @accepted_orders.where.not(countdown_end_time: nil).order(:countdown_end_time)
    end

    private

    def set_store
      @store = current_store_manager.store
    end
  end
end