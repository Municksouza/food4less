module Customers
  class DashboardsController < ApplicationController
    layout "application"
    before_action :authenticate_customer!
    before_action :ensure_customer!
    before_action :set_sidebar_type

    def show
      cart = Cart.find_by(customer_id: current_customer.id, status: 'open')
      @grouped_cart_items = {}

      if cart
        cart.cart_items.includes(:product, product: :store).each do |item|
          store = item.product.store
          @grouped_cart_items[store] ||= []
          @grouped_cart_items[store] << item
        end
      end

      @past_orders = current_customer.orders.includes(:receipt).where.not(status: 'open').order(created_at: :desc)
      @reviews = current_customer.reviews.includes(:store, :order)
      @stores = Store.all
    end

    private

    def ensure_customer!
      redirect_to root_path, alert: "Unauthorized access" unless current_customer
    end

    def set_sidebar_type
      @sidebar_type = "customer"
    end
  end
end