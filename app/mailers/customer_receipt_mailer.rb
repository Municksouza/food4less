class CustomerReceiptMailer < ApplicationMailer
  def send_receipt
    @order = params[:order]
    @receipt = params[:receipt]
    mail(to: @order.customer.email, subject: "Your Receipt for Order ##{@order.id}")
  end
end