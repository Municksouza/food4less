class BusinessAdmins::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]

  def new
    @business_admin = BusinessAdmin.new
    super
  end

  def create
    super do |business_admin|
      if business_admin.persisted?
        # Does not create the store automatically.
        # The business admin can create stores later in the dashboard.
        flash[:notice] = "Welcome, #{business_admin.name}! Please complete your profile."
      else
        # If registration fails, renders the form again.
        flash[:alert] = "There was a problem creating your account. Please try again."
      end
    end
  end

  private

  def after_sign_up_path_for(resource)
     business_admins_business_dashboard_path  # or root_path, as needed
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :address, :zip_code, :phone, :business_number, :logo
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :name, :address, :zip_code, :phone, :business_number, :logo
    ])
  end
end