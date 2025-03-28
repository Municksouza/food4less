class Customers::RegistrationsController < Devise::RegistrationsController
  before_action :logout_if_authenticated, only: [:new]
  before_action :configure_permitted_parameters, only: [:create]

  def create
    build_resource(sign_up_params)

    if resource.save
      flash[:notice] = "Cadastro realizado com sucesso!"
      sign_up(resource_name, resource) # Usa o método do Devise para autenticação correta
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def logout_if_authenticated
    if customer_signed_in? # Verifica se um Customer está logado antes de deslogar
      sign_out(current_customer)
      reset_session
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone])
  end

  def after_sign_up_path_for(resource)
    customer_dashboard_path
  end
end