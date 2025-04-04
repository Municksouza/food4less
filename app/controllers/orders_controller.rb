class OrdersController < ApplicationController
  before_action :authenticate_store_manager!
  before_action :set_order, only: [:show, :accept, :reject]

  def approve
    @order = Order.find(params[:id])
    @order.update(status: "approved")
    redirect_to super_admin_dashboard_path, notice: "Order approved!"
  end

  def reject
    @order = Order.find(params[:id])
    @order.update(status: "rejected")
    redirect_to super_admin_dashboard_path, notice: "Order rejected!"
  end

  def generate_invoice
    @order = Order.find(params[:id])
    # Generate PDF invoice using Prawn
    pdf = Prawn::Document.new
    pdf.text "Invoice - Order ##{@order.id}"
    send_data pdf.render, filename: "invoice_#{@order.id}.pdf", type: "application/pdf"
  end

  def index
    @orders = current_store_manager.store.orders
  end

  def live
    @live_orders = current_store_manager.store.orders.pending
  end

  def history
    @order_history = current_store_manager.store.orders.completed
  end

  private

  def set_order
    @order = current_store_manager.store.orders.find(params[:id])
  end
end
