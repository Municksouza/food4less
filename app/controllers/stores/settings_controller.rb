module Stores
  class SettingsController < ApplicationController
    before_action :authenticate_store_manager!
    before_action :set_store

    def edit; end

    def update
      if @store && @store.update(store_params)
        redirect_to edit_stores_settings_path, notice: "Settings updated successfully."
      else
        flash[:alert] = "Failed to update settings." unless @store
        render :edit
      end
    end

    private

    def set_store
      @store = current_store_manager&.store
      unless @store
        redirect_to root_path, alert: "Store not found." and return
      end
    end

    def store_params
      params.require(:store).permit(:receive_notifications)
    end
  end
end