class PaymentsController < ApplicationController
  before_action :authenticate_store_manager!

  def index
    if current_store_manager&.store
      @payments = current_store_manager.store.payments
    else
      @payments = []
    if current_store_manager&.store
      @payment = current_store_manager.store.payments.build(payment_params)
    else
      redirect_to payments_path, alert: 'Unable to create payment. No store found for the current store manager.' and return
    end
    end
  end

  def create
    @payment = current_store_manager&.store&.payments&.build(payment_params)
    if @payment&.save
      redirect_to payments_path, notice: 'Payment successfully recorded.'
    else
      render :new
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:order_id, :amount, :payment_method, :status, :transaction_id, :payment_date)
  end
end