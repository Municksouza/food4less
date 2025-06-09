# app/controllers/business_admins/stores/sales_controller.rb
module BusinessAdmins
 
    class SalesController < ApplicationController
      before_action :authenticate_business_admin!
      before_action :set_store

      def index
        respond_to do |format|
          format.html do
            begin
              @sales = @store.orders.where(status: 'accepted')
            rescue => e
              logger.error "Error fetching sales: #{e.message}"
              redirect_to business_admins_store_path(@store), alert: 'An error occurred while loading sales.'
            end
          end
          format.turbo_stream
        end
      end

      private

      def set_store
        @store = current_business_admin.stores.friendly.find(params[:store_slug] || params[:store_id] || params[:id])
      end
    end

end