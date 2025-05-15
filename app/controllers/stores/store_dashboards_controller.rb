module Stores
  class StoreDashboardsController < ApplicationController
    layout "application"
    before_action :authenticate_store_manager!
    before_action :set_store
    
    def show  
      @sidebar_type = :store_manager
      @order = @store.orders.find_by(id: params[:order_id]) if params[:order_id].present?
      if params[:order_id].present? && @order.nil?
        Rails.logger.debug "Order not found for store: #{@store.id}, order_id: #{params[:order_id]}"
        flash[:alert] = "Order not found." # Show a flash message instead of redirecting
      end

      # Debugging: Log store and order details
      Rails.logger.debug "Store: #{@store.inspect}, Order: #{@order.inspect}"

      # Load dashboard data
      @pending_orders = @store.orders.pending.order(created_at: :desc)
      @accepted_orders = @store.orders.accepted.order(created_at: :desc)
      @completed_orders = @store.orders.completed.order(created_at: :desc)
      @rejected_orders = @store.orders.rejected.order(created_at: :desc)
      @in_progress_orders = @accepted_orders.where("countdown_end_time IS NOT NULL").order("countdown_end_time ASC")
    end

    private

    def set_store
      @store = current_store_manager.store
      unless @store
        Rails.logger.debug "Store not found for current_store_manager: #{current_store_manager.inspect}"
        redirect_to root_path, alert: "Store not found."
      end
    end
  end
end