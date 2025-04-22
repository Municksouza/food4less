class StoreManagers::SessionsController < Devise::SessionsController
  # GET /store_managers/sign_in
  def new
    super
  end
  
  # POST /store_managers/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(:store_manager, resource)
    yield resource if block_given?
    # Redirects to the store manager's dashboard (adjust the path as needed)
    redirect_to stores_store_dashboard_path
  end
  
  # DELETE /store_managers/sign_out
  def destroy
    super
  end
end