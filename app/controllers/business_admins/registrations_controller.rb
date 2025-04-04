class BusinessAdmins::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]

  def new
    @business_admin = BusinessAdmin.new
    super
  end

  def create
    super do |business_admin|
      if business_admin.persisted?
        # Não cria a loja automaticamente.
        # O business poderá criar lojas no dashboard posteriormente.
        sign_in(:business_admin, business_admin)
        flash[:notice] = "Welcome, #{business_admin.name}! Please complete your profile."
        redirect_to after_sign_up_path_for(business_admin)
      else
        # Se o registro falhar, renderiza o formulário novamente.
        flash[:alert] = "There was a problem creating your account. Please try again."
        redirect_to new_business_admin_registration_path
      end
    end
  end

  private

  def after_sign_up_path_for(resource)
    business_dashboard_path  # ou o root_path, conforme sua necessidade
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :address, :zip_code, :phone, :logo, :email, :password, :password_confirmation
    ])
  end
end