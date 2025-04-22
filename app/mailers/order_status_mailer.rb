class OrderStatusMailer < ApplicationMailer
  default from: 'no-reply@food4less.com'

  def order_confirmed
    @order = params[:order]
    @customer = @order.customer
    @store = @order.store

    mail(to: @customer.email, subject: "Your order at #{@store.name} has been accepted!")
  end
end