module BusinessAdmins
  class OrdersController < ApplicationController
    before_action :authenticate_business_admin!
    before_action :set_store
    before_action :set_order, only: [:show, :approve, :reject, :generate_invoice, :destroy, :update]

    def index
      @orders = @store.orders
    end

    def show
    end

    def update
      @store = current_business_admin.stores.find(params[:store_id])
      @order = @store.orders.find(params[:id])
    
      if @order.update(order_params)
        redirect_to business_admins_store_orders_url(@store), notice: "Order successfully updated."
      else
        redirect_to business_admins_store_orders_url(@store), alert: "Error updating order."
      end
    end

    def approve
      if @order.update(status: "approved")
        @order.reload
        redirect_to business_admins_store_orders_path(@store), notice: "Order successfully approved."
      else
        logger.error "Failed to approve order: #{@order.errors.full_messages.to_sentence}"
        redirect_to business_admins_store_orders_path(@store), alert: "Failed to approve order."
      end
    end

    def reject
      @order.update(status: "rejected")
      redirect_to business_admins_store_orders_path(@store), notice: "Order rejected."
    end

    def generate_invoice
      @order = Order.find(params[:id])
      @store = Store.find(params[:store_id])
      pdf = Prawn::Document.new
      pdf.text "Invoice - Order ##{@order.id}"
      send_data pdf.render, filename: "invoice_#{@order.id}.pdf", type: "application/pdf"
    end

    def live
      @live_orders = @store.orders.where(status: "pending")
    end

    def history
      @order_history = @store.orders.where(status: "completed")
    end

    def destroy
      @order.destroy
      redirect_to business_admins_store_orders_path(@store), notice: "Order successfully deleted."
    end

    private

    def set_store
      @store = current_business_admin.stores.find(params[:store_id])
    end

    def set_order
      @order = @store.orders.find(params[:id])
    end

    def authenticate_business_admin!
      unless business_admin_signed_in?
        redirect_back fallback_location: root_path, allow_other_host: true, alert: "Access denied."
      end
    end

    def order_params
      params.require(:order).permit(:store_id, :status, :total_price)
    end
  end
end