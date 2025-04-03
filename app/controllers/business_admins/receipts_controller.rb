require Rails.root.join("app/services/pdf_receipt_generator")

class BusinessAdmins::ReceiptsController < ApplicationController
  before_action :authenticate_business_admin!

  def show
    @receipt = Receipt.find(params[:id])
    unless @receipt.store.business_admin_id == current_business_admin.id
      redirect_to root_path, alert: "Access denied." and return
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