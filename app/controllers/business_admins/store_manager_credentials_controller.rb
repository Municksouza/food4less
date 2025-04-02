module BusinessAdmins
  class StoreManagerCredentialsController < ApplicationController    
    before_action :authenticate_business_admin!
    before_action :set_store_and_manager
  
    def edit
      # Renderiza o formulário para editar as credenciais
    end
  
    def update
      if @store_manager.update(store_manager_params)
        redirect_to  store_admin_dashboard_path(@store), notice: "Credenciais atualizadas com sucesso."
      else
        flash.now[:alert] = "Erro ao atualizar credenciais."
        render :edit
      end
    end
  
    private
  
    def set_store_and_manager
      # O BusinessAdmin só pode editar as lojas que lhe pertencem
      @store = current_business_admin.stores.find(params[:store_id])
      @store_manager = @store.store_manager
      unless @store_manager
        redirect_to  store_admin_dashboard_path(@store), alert: "Store Manager não encontrado para essa loja."
      end
    end
  
    def store_manager_params
      # Permite a atualização do email e, se informado, da senha
      params.require(:store_manager).permit(:email, :password, :password_confirmation)
    end
  end
end