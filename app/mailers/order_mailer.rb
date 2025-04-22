class OrderMailer < ApplicationMailer
  def notify_customer(order)
    @order = order
    mail(to: order.customer.email, subject: "Your order is being prepared!")
  end
end
