class OrdersController < ApplicationController

  before_action :authenticate_user!

  def approve
    order = Order.find(params[:id])
    order.update(status: "approved")
    redirect_to super_admin_dashboard_path, notice: "Order approved!"
  end

  def reject
    order = Order.find(params[:id])
    order.update(status: "rejected")
    redirect_to super_admin_dashboard_path, notice: "Order rejected!"
  end

  def generate_invoice
    order = Order.find(params[:id])
    # Generate PDF invoice using Prawn
    pdf = Prawn::Document.new
    pdf.text "Invoice - Order ##{order.id}"
    send_data pdf.render, filename: "invoice_#{order.id}.pdf", type: "application/pdf"
  end
  
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
