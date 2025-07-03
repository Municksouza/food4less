# app/controllers/business_admins/receipts_controller.rb
require Rails.root.join("app/services/pdf_receipt_generator")

class BusinessAdmins::ReceiptsController < ApplicationController
  before_action :authenticate_business_admin!
  before_action :set_store
  before_action :set_receipt

  def index
    @receipts = @store.receipts

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
    @receipt = @store.receipts.includes(:store, order: :customer).find_by(id: params[:id])

    unless @receipt
      redirect_to business_admins_store_receipts_path(@store), alert: "Access denied." and return
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

  def set_store
    @store = current_business_admin.stores.friendly.find_by(slug: params[:store_slug])
    unless @store
      redirect_to business_admins_stores_path, alert: "Store not found." and return
    end
  end

  def set_receipt
    @receipt = current_store.receipts.find(params[:id])
  end
end