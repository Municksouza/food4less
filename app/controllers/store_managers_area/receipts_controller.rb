require Rails.root.join("app/services/pdf_receipt_generator")
module StoreManagersArea
  class ReceiptsController < ApplicationController
    before_action :authenticate_store_manager!
    before_action :set_receipt


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

    def download
      if @receipt.pdf_file.attached?
        redirect_to rails_blob_url(@receipt.pdf_file, disposition: "attachment", host: "https://getfood4less.ca")
      else
        redirect_to stores_receipts_path, alert: "PDF not available."
      end
    end

    private

    def set_receipt
      @receipt = current_store.receipts.find(params[:id])
    end
  end
end