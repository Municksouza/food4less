class ReceiptsController < ApplicationController
  before_action :authenticate_store_manager!
  before_action :set_order, only: [:show]

  
  def index
    @receipts = current_store_manager.store.receipts
  end
  
  def show
    @receipt = @order.receipts.find(params[:id]) 
    if @receipt.nil?
      flash[:alert] = "Receipt not available yet."
      redirect_to order_path(@order) and return
    end
  
    pdf = generate_receipt_pdf(@receipt)
    send_data pdf, filename: "receipt_#{@receipt.id}.pdf", type: "application/pdf", disposition: "attachment"
  end
  
  def new
    @receipt = Receipt.new
  end
  
  def create
    @receipt = Receipt.new(receipt_params)
    if @receipt.save
    ReceiptMailer.send_receipt_to_customer(@receipt).deliver_later
    redirect_to receipts_path, notice: 'Recibo criado com sucesso.'
    else
    render :new
    end
  end
  
  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def generate_receipt_pdf(receipt)
    order = receipt.order
    store = order.store
    order_items = order.order_items
    customer = order.customer
  
    tax_rate = 0.11
    tax_amount = order.total_price * tax_rate
    total_with_tax = order.total_price + tax_amount
  

    pdf = Prawn::Document.new
    pdf.text "Receipt ##{receipt.id}", size: 22, style: :bold, align: :center
    pdf.move_down 10
  
    pdf.text "Date of Purchase: #{order.created_at.strftime('%d/%m/%Y %H:%M')}", size: 12, style: :bold
    pdf.move_down 10
  
    pdf.text "Store Information", size: 14, style: :bold
    pdf.text "Name: #{store.name}"
    pdf.text "Address: #{store.address}"
    pdf.text "Phone: #{store.phone_number}"
    pdf.move_down 10
  
    pdf.text "Customer Information", size: 14, style: :bold
    pdf.text "Name: #{customer.full_name || customer.email}"
    pdf.text "Email: #{customer.email}"
    pdf.move_down 10
  
    pdf.text "Payment Information", size: 14, style: :bold
    pdf.text "Payment Method: #{order.payment_method_id.present? ? 'Stripe' : 'PayPal'}"
    pdf.text "Status: #{order.order_payment_status.capitalize}"
    pdf.move_down 10
  
    pdf.text "Order Details", size: 14, style: :bold
    table_data = [["Product", "Quantity", "Unit Price", "Total"]] +
      order_items.map do |item|
      [
        item.product.name,
        "#{item.quantity}x",
        ActionController::Base.helpers.number_to_currency(item.product.discounted_price),
        ActionController::Base.helpers.number_to_currency(item.quantity * item.product.discounted_price)
      ]
      end
  
    pdf.table(table_data, 
      header: true,
      width: pdf.bounds.width,
      row_colors: ["F0F0F0", "FFFFFF"],
      cell_style: { borders: [:top, :bottom, :left, :right], padding: [5, 5, 5, 5] }
    ) do
      row(0).font_style = :bold
      row(0).background_color = 'cccccc'
    end
  
    pdf.move_down 10
    pdf.text "Subtotal: #{ActionController::Base.helpers.number_to_currency(order.total_price)}", size: 12
    pdf.text "Tax (11% - PST & GST): #{ActionController::Base.helpers.number_to_currency(tax_amount)}", size: 12, style: :bold
    pdf.text "Total Amount (incl. tax): #{ActionController::Base.helpers.number_to_currency(total_with_tax)}", size: 16, style: :bold
  
    pdf.render
  end
end