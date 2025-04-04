class BusinessInvoiceMailer < ApplicationMailer
  def send_receipt
    @order = params[:order]
    @receipt = params[:receipt]
    mail(to: @order&.store&.user&.email, subject: "Receipt Sent for Order ##{@order&.id}")
  end
end