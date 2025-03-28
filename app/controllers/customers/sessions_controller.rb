class Customers::SessionsController < Devise::SessionsController
  def create
    customer = Customer.find_by(email: params[:customer][:email])

    if customer&.valid_password?(params[:customer][:password])
      sign_in_and_redirect customer, event: :authentication
      flash[:notice] = "Login bem-sucedido!"
    else
      flash[:alert] = "Email ou senha inválidos"
      render :new
    end
  end

  def destroy
    sign_out(:customer)
    redirect_to root_path, notice: "Você saiu com sucesso."
  end

  protected

  def after_sign_in_path_for(resource)
    customer_dashboard_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end