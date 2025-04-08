# app/controllers/stores/orders_controller.rb
module Stores
    class OrdersController < ApplicationController
      before_action :authenticate_store_manager!
  
      def index
        @orders = current_store_manager.store.orders
      end
  
      def new 
        @order = current_store_manager.store.orders.new
      end
      def create
        @order = current_store_manager.store.orders.new(order_params)
        if @order.save
          redirect_to stores_orders_path, notice: "Pedido criado com sucesso."
        else
          render :new
        end
      end
      
      def show
        @order = current_store_manager.store.orders.find(params[:id])
      end
  
      def approve
        @order = current_store_manager.store.orders.find(params[:id])
        @order.update(status: 'approved')
        redirect_to stores_orders_path, notice: 'Pedido aprovado.'
      end
  
      def reject
        @order = current_store_manager.store.orders.find(params[:id])
        @order.update(status: 'rejected')
        redirect_to stores_orders_path, notice: 'Pedido rejeitado.'
      end
  
      def live
        @live_orders = current_store_manager.store.orders.pending
      end
    
      def history
        @order_history = current_store_manager.store.orders.completed
      end
    end

    def generate_invoice
      @order = Order.find(params[:id])
      # Generate PDF invoice using Prawn
      pdf = Prawn::Document.new
      pdf.text "Invoice - Order ##{@order.id}"
      send_data pdf.render, filename: "invoice_#{@order.id}.pdf", type: "application/pdf"
    end

    def destroy
      @order = current_store_manager.store.orders.find(params[:id])
      @order.destroy
      redirect_to stores_orders_path, notice: "Pedido excluído."
    end

    def edit
      @order = current_store_manager.store.orders.find(params[:id])
    end 

    def update
      @order = current_store_manager.store.orders.find(params[:id])
      if @order.update(order_params)
        redirect_to stores_orders_path, notice: "Pedido atualizado com sucesso."
      else
        render :edit
      end
    end

    private
    def authenticate_store_manager!
      unless store_manager_signed_in?
        redirect_to root_path, alert: "Acesso negado."
      end
    end

    def set_order
      @order = current_store_manager.store.orders.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status, :total_price, :customer_name, :customer_email)
    end
end