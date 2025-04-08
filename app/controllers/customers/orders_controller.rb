# app/controllers/customers/orders_controller.rb
module Customers
    class OrdersController < ApplicationController
      before_action :authenticate_customer!
  
      def index
        @orders = current_customer.orders
      end
  
      def show
        @order = current_customer.orders.find(params[:id])
      end
  
      def new
        @order = current_customer.orders.new
      end
  
      def edit
        @order = current_customer.orders.find(params[:id])
      end

      def update
        @order = current_customer.orders.find(params[:id])
        if @order.update(order_params)
          redirect_to customers_orders_path(@order), notice: 'Pedido atualizado com sucesso.'
        else
          render :edit
        end
      end

      def destroy
        @order = current_customer.orders.find(params[:id])
        @order.destroy
        redirect_to customers_orders_path, notice: 'Pedido excluído com sucesso.'
      end
      
      def create
        @order = current_customer.orders.new(order_params)
        if @order.save
          redirect_to customers_orders_path(@order), notice: 'Pedido criado com sucesso.'
        else
          render :new
        end
      end
  
      private
  
      def authenticate_customer!
        unless customer_signed_in?
          redirect_to new_customer_session_path, alert: 'Você precisa estar logado para acessar esta página.'
        end
      end

      def order_params
        params.require(:order).permit(:product_id, :quantity, :store_id, :total_price, :status, :customer_id)
      end
    end
end