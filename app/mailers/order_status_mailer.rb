class OrderStatusMailer < ApplicationMailer
  def ready_for_pickup(order)
    @order = order
    mail(to: order.customer.email, subject: "Your order ##{order.id} is ready for pickup!")
  end
end