class Customers::CartsController < ApplicationController
  before_action :authenticate_customer!

  def show
    session[:previous_url] ||= request.referer
    @cart = session[:cart] || {}
  end

  def add_item
    product_id = params[:product_id].to_s
    store_id = Product.find_by(id: product_id)&.store_id.to_s

    session[:cart] ||= {}
    session[:cart][store_id] ||= {}
    session[:cart][store_id][product_id] ||= 0
    session[:cart][store_id][product_id] += 1
    session[:previous_url] = request.referer

    flash[:notice] = "Product added to cart!"
    render :after_add 
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
  
    # Force minimum quantity of 1
    quantity = 1 if quantity < 1
  
    # Check if store_id is valid
    if store_id.blank?
      flash[:alert] = "Invalid or not found product."
      return redirect_to customers_cart_path
    end
  
    # Ensure the session exists
    session[:cart] ||= {}
    session[:cart][store_id] ||= {}
  
    # Update if the product is already in the cart
    if session[:cart][store_id].key?(product_id)
      session[:cart][store_id][product_id] = quantity
      flash[:notice] = "Quantity successfully updated."
    else
      flash[:alert] = "Product not found in the cart."
    end
  
    redirect_to customers_cart_path
    puts "🛠️ RECEBIDO: produto #{product_id} | nova quantidade: #{quantity}"
  end

  def clear_cart
    session[:cart] = {}
    redirect_to customers_cart_path, notice: "Cart cleared."
  end

  def checkout
    store_id = params[:store_id]
    cart = session[:cart] || {}
  
    if cart[store_id].blank?
      return redirect_to customers_cart_path, alert: "Your cart for this store is empty."
    end
  
    store = Store.find_by(id: store_id)
    return redirect_to customers_cart_path, alert: "Store not found." unless store
  
    order = current_customer.orders.create!(store: store, status: "accepted", total_price: 0)
  
    cart[store_id].each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
  
      order.order_items.create!(
        price: product.price,
        product: product,
        quantity: quantity,
        unit_price: product.price
      )
      order.total_price += product.price * quantity
    end
  
    order.save!
  
    Payment.create!(
      order: order,
      store: store,
      amount: order.total_price,
      payment_method: %w[PayPal Stripe].sample,
      status: "paid",
      transaction_id: SecureRandom.hex(10),
      payment_date: Time.current
    )
  
    receipt = Receipt.create!(
      order: order,
      store: store,
      amount: order.total_price,
      content: "Receipt for Order ##{order.id}",
      receipt_type: "store"
    )
  
    # Clear only the items for this store
    session[:cart].delete(store_id)
  
    redirect_to customers_cart_path, notice: "Checkout completed for #{store.name}!"
    begin
      ReceiptMailer.send_receipt_to_customer(receipt).deliver_now
      ReceiptMailer.send_receipt_to_store(receipt).deliver_now
      ReceiptMailer.send_receipt_to_business(receipt).deliver_now
    rescue => e
      Rails.logger.warn "❌ Falha ao enviar recibo: #{e.message}"
    end
  end
end