module Customers
  class CartsController < ApplicationController
    before_action :authenticate_customer!
    before_action :load_cart, only: %i[show checkout clear_cart]


    def show
      @cart = session[:cart] || {}
      @store_totals = {}
      @overall_total = 0

      @cart.each do |store_id, products|
        store_total = 0
        products.each do |product_id, quantity|
          product = Product.find_by(id: product_id)
          next unless product
          subtotal = quantity.to_i * product.price.to_f
          store_total += subtotal
        end
        @store_totals[store_id] = store_total
        @overall_total += store_total
      end

      respond_to do |format|
        format.html
        format.json { render json: { cart: @cart, totals: @store_totals, overall_total: @overall_total } }
      end
    end

    def add_item
      product_id = params[:product_id].to_s
      store_id = Product.find_by(id: product_id)&.store_id&.to_s

      if store_id.blank?
        flash[:alert] = "Product not found."
        return redirect_to root_path
      end

      session[:cart] ||= {}
      session[:cart][store_id] ||= {}
      session[:cart][store_id][product_id] ||= 0
      session[:cart][store_id][product_id] += 1

      flash[:notice] = "Product added to cart."
      redirect_to customers_cart_path
    end

    def remove_item
      product_id = params[:product_id].to_s
      store_id = Product.find_by(id: product_id)&.store_id.to_s
      session[:cart][store_id].delete(product_id)
      session[:cart].delete(store_id) if session[:cart][store_id].blank?

      redirect_to customers_cart_path, notice: "Item removed from cart."
    end

    def update_item
      product_id = params[:product_id].to_s
      store_id = Product.find_by(id: product_id)&.store_id&.to_s
      quantity = params[:quantity].to_i

      if quantity < 1
        flash[:alert] = "Quantity must be at least 1."
        return redirect_to customers_cart_path
      end

      session[:cart] ||= {}
      session[:cart][store_id] ||= {}

      if session[:cart][store_id].key?(product_id)
        session[:cart][store_id][product_id] = quantity
        flash[:notice] = "Quantity successfully updated."
      else
        flash[:alert] = "Product not found in the cart."
      end

      redirect_to customers_cart_path
    end

    def clear_cart
      session[:cart] = {}
      redirect_to customers_cart_path, notice: "Cart cleared."
    end

    def checkout
      store_id = params[:store_id].to_s
      if @cart[store_id].blank?
        return redirect_to customers_cart_path, alert: "Your cart for this store is empty."
      end
    
      store = Store.find_by(id: store_id)
      return redirect_to customers_cart_path, alert: "Store not found." unless store
    
      ready_minutes = 30
    
      # 1) Cria o order com campos zerados
      order = current_customer.orders.create!(
        store:             store,
        status:            "pending",
        subtotal:          0.0,
        taxes:             0.0,
        total_price:       0.0,
        total_with_taxes:  0.0,
        ready_in_minutes:  ready_minutes
      )
    
      # 2) Popula os order_items e acumula subtotal
      subtotal = 0.0
      @cart[store_id].each do |product_id, qty|
        product     = Product.find_by(id: product_id)
        next unless product
    
        quantity    = qty.to_i
        unit_price  = product.price
        line_total  = unit_price * quantity
        subtotal   += line_total
    
        order.order_items.create!(
          product:     product,
          quantity:    quantity,
          unit_price:  unit_price,
          total_price: line_total,
          price:       unit_price
        )
      end
    
      # 3) Calcula impostos e total final
      tax_rate = 0.11
      taxes    = (subtotal * tax_rate).round(2)
      total    = subtotal + taxes
    
      order.update!(
        subtotal:           subtotal,
        taxes:              taxes,
        total_price:        total,
        total_with_taxes:   total,
        countdown_end_time: Time.current + ready_minutes.minutes
      )
    
      # 4) Cria pagamento e recibo
      Payment.create!(
        order:          order,
        store:          store,
        amount:         total,
        payment_method: %w[PayPal Stripe].sample,
        status:         "paid",
        transaction_id: SecureRandom.hex(10),
        payment_date:   Time.current
      )
      Receipt.create!(
        order:        order,
        store:        store,
        amount:       total,
        content:      "Receipt for Order ##{order.id}",
        receipt_type: "store"
      )
    
      # 5) Limpa o carrinho desta loja
      @cart.delete(store_id)
      session[:cart] = @cart
    
      # 6) Broadcast único
      OrderBroadcaster.new(order).broadcast_new
    
      # 7) Envia emails de recibo (silencia falhas)
      begin
        ReceiptMailer.send_receipt_to_customer(order).deliver_now
        ReceiptMailer.send_receipt_to_store(order).deliver_now
        ReceiptMailer.send_receipt_to_business(order).deliver_now
      rescue => e
        Rails.logger.warn "Receipt email failed: #{e.message}"
      end
    
      redirect_to customers_cart_path, notice: "Checkout completed for #{store.name}!"
    end

    private

    def authenticate_customer!
      unless customer_signed_in?
        redirect_to new_customer_session_path, alert: 'You need to be logged in to access this page.'
      end
    end

    def load_cart
      @cart = session[:cart] || {}
    end
  end
end