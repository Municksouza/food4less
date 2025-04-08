module Customers
  class CartsController < ApplicationController
    before_action :authenticate_customer!

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
     # Exemplo de render para testes
      respond_to do |format|
        format.html # show.html.erb
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
      cart = session[:cart] || {}
    
      if cart[store_id].blank?
        flash[:alert] = "Your cart for this store is empty."
        return redirect_to customers_cart_path
      end
    
      store = Store.find_by(id: store_id)
      return redirect_to customers_cart_path, alert: "Store not found." unless store
    
      order = current_customer.orders.create!(
        store: store,
        status: "accepted",
        total_price: 0
      )
    
      total_price = 0
    
      cart[store_id].each do |product_id, quantity|
        product = Product.find_by(id: product_id)
        next unless product
    
        quantity = quantity.to_i
        unit_price = product.price
        subtotal = unit_price * quantity
        
        order.order_items.create!(
          price: unit_price,
          product: product,
          quantity: quantity,
          unit_price: unit_price
        )
        
        total_price += subtotal
      end
    
      order.update!(total_price: total_price)
    
      Payment.create!(
        order: order,
        store: store,
        amount: total_price,
        payment_method: %w[PayPal Stripe].sample,
        status: "paid",
        transaction_id: SecureRandom.hex(10),
        payment_date: Time.current
      )
    
      receipt = Receipt.create!(
        order: order,
        store: store,
        amount: total_price,
        content: "Receipt for Order ##{order.id}",
        receipt_type: "store"
      )
    
      # Clear only the items for this store
      session[:cart].delete(store_id)
    
      begin
        ReceiptMailer.send_receipt_to_customer(receipt).deliver_now
        ReceiptMailer.send_receipt_to_store(receipt).deliver_now
        ReceiptMailer.send_receipt_to_business(receipt).deliver_now
      rescue => e
        Rails.logger.warn "❌ Falha ao enviar recibo: #{e.message}"
      end
    
      redirect_to customers_cart_path, notice: "Checkout completed for #{store.name}!"
    end
  end
end