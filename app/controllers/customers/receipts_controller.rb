require Rails.root.join("app/services/pdf_receipt_generator")

class Customers::ReceiptsController < ApplicationController
  before_action :authenticate_customer!

  def show
    @receipt = Receipt.find(params[:id])
    unless @receipt.order.customer_id == current_customer.id
      redirect_to root_path, alert: "You are not authorized to view this receipt." and return
    end
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PdfReceiptGenerator.generate(@receipt)
        send_data pdf, filename: "Receipt_#{@receipt.id}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
end