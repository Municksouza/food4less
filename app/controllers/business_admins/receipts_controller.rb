require Rails.root.join("app/services/pdf_receipt_generator")

class BusinessAdmins::ReceiptsController < ApplicationController
  before_action :authenticate_business_admin!


  def index
    @stores = current_business_admin.stores
    store_ids = @stores.pluck(:id)

    @receipts = Receipt.where(store_id: store_ids)

    if params.dig(:filters, :store_id).present?
      @receipts = @receipts.where(store_id: params[:filters][:store_id])
    end

    if params.dig(:filters, :date).present?
      date = Date.parse(params[:filters][:date]) rescue nil
      @receipts = @receipts.where("DATE(created_at) = ?", date) if date
    end

    if params.dig(:filters, :sort).present?
      case params[:filters][:sort]
      when "date_asc"
        @receipts = @receipts.order(created_at: :asc)
      when "date_desc"
        @receipts = @receipts.order(created_at: :desc)
      when "amount_asc"
        @receipts = @receipts.order(amount: :asc)
      when "amount_desc"
        @receipts = @receipts.order(amount: :desc)
      end
    else
      @receipts = @receipts.order(created_at: :desc)
    end
  end
  
  def show
    store_ids = current_business_admin.stores.pluck(:id)
    @receipt = Receipt.includes(:store, order: :customer).find_by(id: params[:id], store_id: store_ids)
  
    unless @receipt
      redirect_to business_admins_receipts_path, alert: "Access denied." and return
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