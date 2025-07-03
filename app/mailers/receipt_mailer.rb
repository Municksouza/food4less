class ReceiptMailer < ApplicationMailer
  require 'prawn'
  require 'prawn/table'

  default from: "admin@getfood4less.ca"

  # ✅ Send receipt to Customer
  def send_receipt_to_customer(receipt)
    @receipt = receipt
    @order = receipt.order
    @customer = @order.customer
    @store = @order.store
    @order_items = @order.order_items
    @payment_method = @order.payment&.payment_method || "Unknown"    
    @purchase_date = @order.created_at.strftime("%d/%m/%Y %H:%M")

    pdf = generate_receipt_pdf(@receipt)
    attachments["Receipt_#{receipt.id}.pdf"] = { mime_type: 'application/pdf', content: pdf }

    mail(to: @customer.email, subject: "Your Food4Less Receipt ##{receipt.id}") do |format|
      format.text { render plain: "Receipt attached." }
    end
  end

  # ✅ Send receipt to Store (Store Manager)
  def send_receipt_to_store(receipt)
    @receipt = receipt
    @order = receipt.order
    @store = @order.store
    @order_items = @order.order_items
    @payment_method = @order.payment&.payment_method || "Unknown"    
    @purchase_date = @order.created_at.strftime("%d/%m/%Y %H:%M")

    pdf = generate_receipt_pdf(@receipt)
    attachments["Receipt_#{receipt.id}.pdf"] = { mime_type: 'application/pdf', content: pdf }

    mail(to: @store.business_admin.email, subject: "Receipt for Order ##{receipt.id}") do |format|
      format.text { render plain: "Receipt attached." }
    end
  end

  # ✅ Send receipt to Business Admin
  def send_receipt_to_business(receipt)
    @receipt = receipt
    @order = receipt.order
    @store = @order.store
    @order_items = @order.order_items
    @business = @store.business_admin
    @payment_method = @order.payment&.payment_method || "Unknown"    
    @purchase_date = @order.created_at.strftime("%d/%m/%Y %H:%M")

    pdf = generate_receipt_pdf(@receipt)
    attachments["Receipt_#{receipt.id}.pdf"] = { mime_type: 'application/pdf', content: pdf }

    mail(to: @business.email, subject: "Receipt for Order ##{receipt.id}") do |format|
      format.text { render plain: "Receipt attached." }
    end
  end

  private

  def generate_receipt_pdf(receipt)
    order = receipt.order
    store = order.store
    order_items = order.order_items
    customer = order.customer

    purchase_date = order.created_at.strftime("%d/%m/%Y %H:%M")
    payment_method = order.payment&.payment_method || "Unknown"

    tax_rate = 0.11
    tax_amount = order.total_price * tax_rate
    total_with_tax = order.total_price + tax_amount

    pdf = Prawn::Document.new

    # ✅ LOGO via ActiveStorage download (compatível com S3, Azure etc.)
    if store.logo.attached?
      pdf.image StringIO.new(store.logo.download), width: 100, position: :center
      pdf.move_down 10
    end

    pdf.text "Receipt ##{receipt.id}", size: 22, style: :bold, align: :center
    pdf.move_down 10

    pdf.text "Date of Purchase: #{purchase_date}", size: 12, style: :bold
    pdf.move_down 10

    pdf.text "Store Information", size: 14, style: :bold
    pdf.text "Name: #{store.name}"
    pdf.text "Address: #{store.address}"
    pdf.text "Phone: #{store.phone}"
    pdf.move_down 10

    pdf.text "Customer Information", size: 14, style: :bold
    pdf.text "Name: #{customer.name || customer.email}"
    pdf.text "Email: #{customer.email}"
    pdf.move_down 10

    pdf.text "Payment Information", size: 14, style: :bold
    pdf.text "Payment Method: #{payment_method}"
    pdf.text "Status: #{order.payment&.status&.capitalize || 'Unknown'}"
    pdf.move_down 10

    pdf.text "Order Details", size: 14, style: :bold
    table_data = [["Product", "Quantity", "Unit Price", "Total"]] +
      order_items.map do |item|
        [
          item.product.name,
          "#{item.quantity}x",
          ActionController::Base.helpers.number_to_currency(item.product.price),
          ActionController::Base.helpers.number_to_currency(item.quantity * item.product.price)
        ]
      end

    pdf.table(table_data, header: true, width: pdf.bounds.width,
      row_colors: ["F0F0F0", "FFFFFF"],
      cell_style: { borders: [:top, :bottom, :left, :right], padding: [5, 5, 5, 5] }) do
      row(0).font_style = :bold
      row(0).background_color = 'cccccc'
    end

    pdf.move_down 10
    pdf.text "Subtotal: #{ActionController::Base.helpers.number_to_currency(order.total_price)}", size: 12
    pdf.text "Tax (11% - PST & GST): #{ActionController::Base.helpers.number_to_currency(tax_amount)}", size: 12, style: :bold
    pdf.text "Total Amount (incl. tax): #{ActionController::Base.helpers.number_to_currency(total_with_tax)}", size: 16, style: :bold

    pdf.render
  end

  def attach_pdf(receipt, template_path)
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(
        template: template_path,
        layout: 'pdf',
        locals: { receipt: receipt }
      )
    )

    attachments["receipt_order_#{receipt.order.id}.pdf"] = {
      mime_type: 'application/pdf',
      content: pdf
    }
  end
end