module StoreManagersArea
  class SalesController < ApplicationController
    before_action :authenticate_store_manager!
    before_action :set_store
    require 'csv'

    def index
      @store = current_store_manager.store
      @orders = @store.orders
      @accepted_orders = @orders.where(status: "accepted")
      @rejected_orders = @orders.where(status: "rejected")

      @total_sales_amount = @accepted_orders.sum(:total_price)
      @total_accepted = @accepted_orders.count
      @total_rejected = @rejected_orders.count
      @top_products = @store.orders.where(status: "accepted")
        .joins(:order_items)
        .group("order_items.product_id")
        .select("order_items.product_id, SUM(order_items.quantity) as total_quantity")
        .order("total_quantity DESC")
        .limit(5)
      @sales_by_day = @accepted_orders.group_by_day(:created_at).sum(:total_price)

      @top_products_chart = @store.orders.where(status: "accepted")
        .joins(order_items: :product)
        .group("products.name")
        .sum("order_items.quantity")
    end

    def export_csv
      @store = current_store_manager.store
      orders = @store.orders.where(status: "accepted")

      csv_data = CSV.generate(headers: true) do |csv|
        csv << ["Order ID", "Customer", "Total", "Date"]
        orders.each do |order|
          csv << [order.id, order.customer_name, order.total_price, order.created_at.to_date]
        end
      end

      send_data csv_data, filename: "sales_#{Date.today}.csv"
    end

    def export_pdf
      @store = current_store_manager.store
      orders = @store.orders.where(status: "accepted")

      pdf = Prawn::Document.new
      pdf.text "Sales Report", size: 20, style: :bold
      pdf.move_down 20

      orders.each do |order|
        pdf.text "Order ##{order.id} - #{order.customer_name} - $#{order.total_price}"
      end

      send_data pdf.render, filename: "sales_#{Date.today}.pdf", type: "application/pdf"
    end

    private

    def set_store
      @store = current_business_admin.stores.friendly.find(params[:store_slug] || params[:store_id] || params[:id])
    end
  end
end