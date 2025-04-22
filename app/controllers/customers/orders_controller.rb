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

    def create
      # ───────────────────────────────────────────────────────────────
      # Detecta nested ou root-level order_items_attributes
      # ───────────────────────────────────────────────────────────────
      raw_items = if params.dig(:order, :order_items_attributes).present?
                    params[:order][:order_items_attributes]
                  else
                    params[:order_items_attributes]
                  end
    
      if raw_items.present?
        # Pega store_id e ready_in_minutes onde estiverem
        store_id       = (params.dig(:order, :store_id) || params[:store_id]).to_s
        ready_minutes  = (params.dig(:order, :ready_in_minutes) || params[:ready_in_minutes]).to_i
        ready_minutes  = 30 if ready_minutes <= 0
    
        store = Store.find_by(id: store_id)
        return redirect_to(customers_cart_path, alert: "Store not found.") unless store
    
        # Normaliza para array de hashes
        items = raw_items.is_a?(Hash) ? raw_items.values : Array(raw_items)
    
        @order = current_customer.orders.build(
          store:             store,
          status:            "pending",
          ready_in_minutes:  ready_minutes
        )
    
        ActiveRecord::Base.transaction do
          @order.save!
          total = 0
    
          items.each do |attrs|
            pid = attrs[:product_id]   || attrs["product_id"]
            qty = (attrs[:quantity]    || attrs["quantity"]).to_i
            up  = (attrs[:unit_price]  || attrs["unit_price"]).to_f
    
            next if qty <= 0
            product = Product.find_by(id: pid)
            next unless product
    
            @order.order_items.create!(
              product:    product,
              quantity:   qty,
              unit_price: up
            )
            total += up * qty
          end
    
          @order.update!(
            total_price:        total,
            countdown_end_time: Time.current + @order.ready_in_minutes.minutes
          )
    
          OrderBroadcaster.new(@order).broadcast_new
        end
    
        redirect_to customers_orders_path, notice: "Order successfully created!"
        return
      end
    
      # ───────────────────────────────────────────────────────────────
      # Fluxo legacy: carrinho na sessão
      # ───────────────────────────────────────────────────────────────
      session_cart = session[:cart] || {}
      store_id     = params[:store_id].to_s
      store_cart   = session_cart[store_id]
    
      if store_cart.blank?
        redirect_to customers_cart_path, alert: "Store cart is empty or invalid."
        return
      end
    
      store = Store.find_by(id: store_id)
      unless store
        redirect_to customers_cart_path, alert: "Store not found."
        return
      end
    
      ready_minutes = params[:ready_in_minutes].to_i
      ready_minutes = 30 if ready_minutes <= 0
    
      order = current_customer.orders.build(
        store:             store,
        status:            "pending",
        total_price:       0,
        ready_in_minutes:  ready_minutes
      )
    
      ActiveRecord::Base.transaction do
        order.save!
        total_price = 0
    
        store_cart.each do |product_id, quantity|
          product = Product.find_by(id: product_id)
          next unless product
    
          qty   = quantity.to_i
          next if qty <= 0
    
          up       = product.discount_price || product.original_price
          subtotal = up * qty
    
          order.order_items.create!(
            product:    product,
            quantity:   qty,
            unit_price: up
          )
          total_price += subtotal
        end
    
        order.update!(
          total_price:        total_price,
          countdown_end_time: Time.current + order.ready_in_minutes.minutes
        )
    
        session[:cart].delete(store_id)
        OrderBroadcaster.new(order).broadcast_new
      end
    
      redirect_to customers_orders_path, notice: "Order successfully created!"
    rescue ActiveRecord::RecordInvalid => e
      @order&.destroy
      redirect_to customers_cart_path, alert: "Failed to create order: #{e.message}"
    end

    def destroy
      @order = current_customer.orders.find(params[:id])
      @order.destroy
      redirect_to customers_orders_path, notice: 'Order successfully deleted.'
    end

    private

    def authenticate_customer!
      redirect_to new_customer_session_path, alert: 'You need to be logged in to access this page.' unless customer_signed_in?
    end

    def order_params
      params.require(:order).permit(
        :store_id,
        :ready_in_minutes,
        order_items_attributes: %i[product_id quantity unit_price]
      )
    end
  end
end