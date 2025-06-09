module BusinessAdmins
  module Stores
    class FinancialController < ApplicationController
      before_action :authenticate_business_admin!
      before_action :set_store

      def index
        @total_sales = @store.orders.accepted.sum(:total_amount)
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
        # relatório financeiro
      end

      def overview; end
      def monthly_report; end
      def yearly_report; end

      private

      def set_store
        @store = current_business_admin.stores.friendly.find(params[:store_slug])
      end
    end
  end
end