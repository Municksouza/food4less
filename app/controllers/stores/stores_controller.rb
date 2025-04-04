module Stores
    class StoresController < Shared::StoresBaseController
      before_action :authenticate_store_manager!
  
      private
  
      def set_store
        @store = current_store_manager.store
      end
  
      def after_update_path
        stores_store_path
      end
    end
end