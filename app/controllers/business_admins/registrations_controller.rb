class BusinessAdmins::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters, only: [:create]

    def new
      @business_admin = BusinessAdmin.new
      super
    end
  
    def create
      super do |business_admin|
        if business_admin.persisted?
          # Criar automaticamente uma Store para o Business Admin
          store = business_admin.stores.create!(
            name: "#{business_admin.name}'s Store",
            email: business_admin.email,
            phone: business_admin.phone,
            address: business_admin.address,
            zip_code: business_admin.zip_code
          )
  
          # Criar um Store Manager com login gerado
          generated_password = Devise.friendly_token.first(8)
          store_manager = StoreManager.create!(
            email: store.email,
            password: generated_password,
            password_confirmation: generated_password,
            name: store.name,
            phone: store.phone,
            address: store.address,
            zip_code: store.zip_code
          )
  
          # Enviar email com credenciais
          StoreMailer.send_credentials(store, store_manager, generated_password).deliver_now
        end
      end
    end
  
    private
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :address, :zip_code, :email, :password, :password_confirmation])
    end
  end