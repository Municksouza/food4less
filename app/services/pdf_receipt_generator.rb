module PdfReceiptGenerator
    extend self
  
    def generate(receipt)
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

      if store.logo.attached?
        logo_path = ActiveStorage::Blob.service.send(:path_for, store.logo.key)
        pdf.image logo_path, width: 100, height: 100, position: :center
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
  
      pdf.text "Payment Method: #{payment_method}"
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
  
      pdf.table(table_data, header: true, width: pdf.bounds.width, row_colors: ["F0F0F0", "FFFFFF"]) do
        row(0).font_style = :bold
        row(0).background_color = 'cccccc'
      end
  
      pdf.move_down 10
      pdf.text "Subtotal: #{ActionController::Base.helpers.number_to_currency(order.total_price)}"
      pdf.text "Tax (11%): #{ActionController::Base.helpers.number_to_currency(tax_amount)}"
      pdf.text "Total: #{ActionController::Base.helpers.number_to_currency(total_with_tax)}", size: 14, style: :bold
  
      pdf.render
    end
  end