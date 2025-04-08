# app/controllers/super_admin/orders_controller.rb
module SuperAdmins
  class OrdersController < ApplicationController
    before_action :authenticate_super_admin!
    before_action :set_order, only: [:show, :approve, :reject, :generate_invoice, :destroy]

    def index
      @orders = Order.all
    end

    def show
      @order = Order.find(params[:id])
    end

    def approve
      @order = Order.find(params[:id])
      @order.update(status: "approved")
      redirect_to super_admins_orders_path, notice: "Order approved successfully."
    end

    def reject
      @order = Order.find(params[:id])
      @order.update(status: "rejected")
      redirect_to super_admins_orders_path, notice: "Order rejected."
    end

    def generate_invoice
      @order = Order.find(params[:id])
      # Generate PDF invoice using Prawn
      pdf = Prawn::Document.new
      pdf.text "Invoice - Order ##{@order.id}"
      send_data pdf.render, filename: "invoice_#{@order.id}.pdf", type: "application/pdf"
    end


    def live
      @live_orders = current_store_manager.store.orders.pending
    end

    def history
      @order_history = current_store_manager.store.orders.completed
    end

    def destroy
      @order = Order.find(params[:id])
      @order.destroy
      redirect_to orders_path, notice: "Order deleted."
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def authenticate_super_admin!
      unless super_admin_signed_in?
        redirect_to root_path, alert: "Access denied."
      end
    end
  end
end