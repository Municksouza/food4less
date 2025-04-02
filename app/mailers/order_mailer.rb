class OrderMailer < ApplicationMailer
    def order_ready_email(order)
      @order = order
      mail(to: @order.customer.email, subject: "Your Order is Ready for Pickup!")
    end

    def invoice_to_customer(order)
      @order = order
      mail(to: @order.customer.email, subject: "Sua Invoice - Pedido ##{@order.id}")
    end
  
    def invoice_to_business(order)
      @order = order
      mail(to: @order.store.business.email, subject: "Invoice para o Pedido ##{@order.id}")
    end
end