class StoresController < ApplicationController
  before_action :authenticate_business_admin!

  def new
    @store = Store.new
  end

  def create
    @store = current_business_admin.stores.build(store_params)
    generated_password = Devise.friendly_token.first(8) # Senha aleatória para o Store Manager

    # Cria o Store Manager para a nova loja.
    store_manager = StoreManager.create!(
      email: @store.email,
      password: generated_password,
      password_confirmation: generated_password
      # Aqui você pode adicionar outros atributos se necessário.
    )

    if @store.save
      # Envie as credenciais para o e-mail informado pelo business.
      # Supondo que o formulário inclua um campo "store_manager_recipient_email"
      StoreMailer.send_credentials(
        @store, 
        store_manager, 
        generated_password, 
        params[:store_manager_recipient_email] || @store.email
      ).deliver_now
      redirect_to business_dashboard_path, notice: "Store created successfully. Credentials sent to the provided email."
    else
      render :new
    end
  end

  private

  def store_params
    params.require(:store).permit(:name, :email, :phone, :address, :zip_code, :logo, :description)
  end
end