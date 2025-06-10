require Rails.root.join("app/services/pdf_receipt_generator")
module StoreManagersArea
  class ReceiptsController < ApplicationController
    before_action :authenticate_store_manager!

    def show
      @receipt = Receipt.find(params[:id])
      unless @receipt.store_id == current_store_manager.store_id
        redirect_to stores_dashboard_path, alert: "Access denied." and return
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
end