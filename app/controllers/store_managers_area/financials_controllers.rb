module StoreManagersArea
  class FinancialsController < ApplicationController
    before_action :authenticate_store_manager!
    before_action :set_store

    def index
      # Visão geral financeira da loja
    end

    def receipts
      @receipts = @store.receipts
    end

    def refunds
      @refunds = @store.refunds
    end

    def payments
      @payments = @store.payments
    end

    def reports
      # Lógica para relatórios financeiros da loja
    end

    private

    def set_store
      @store = Store.find_by!(slug: params[:slug])
    end
  end
end