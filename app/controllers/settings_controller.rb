class SettingsController < ApplicationController
    before_action :authenticate_store_manager!
  
    def edit
      @store_manager = current_store_manager
    end
  
    def update
      @store_manager = current_store_manager
      if @store_manager.update(settings_params)
        redirect_to store_dashboard_path, notice: "Configurações atualizadas com sucesso."
      else
        flash.now[:alert] = "Erro ao atualizar configurações."
        render :edit
      end
    end
  
    private
  
    def settings_params
      params.require(:store_manager).permit(:email, :password, :password_confirmation)
    end
end