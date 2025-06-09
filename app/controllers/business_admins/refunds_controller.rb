module BusinessAdmins
  class RefundsController < ApplicationController
    before_action :authenticate_business_admin!
    before_action :set_store
    before_action :set_refund, only: [:show, :edit, :update, :destroy]

    def index
      @refunds = @store.refunds.order(created_at: :desc)
    end

    def show
    end

    def new
      @refund = @store.refunds.build
    end

    def create
      @refund = @store.refunds.build(refund_params)
      if @refund.save
        redirect_to business_admins_store_refund_path(@store, @refund), notice: "Refund successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @refund.update(refund_params)
        redirect_to business_admins_store_refund_path(@store, @refund), notice: "Refund updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @refund.destroy
      redirect_to business_admins_store_refunds_path(@store), notice: "Refund deleted successfully."
    end

    private

    def set_store
      @store = current_business_admin.stores.friendly.find(params[:store_slug] || params[:store_id])
    end

    def set_refund
      @refund = @store.refunds.find(params[:id])
    end

    def refund_params
      params.require(:refund).permit(:order_id, :amount, :reason, :status)
    end
  end
end