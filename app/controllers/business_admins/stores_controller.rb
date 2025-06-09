module BusinessAdmins
  class StoresController < Shared::StoresBaseController
    before_action :authenticate_business_admin!
    before_action :set_store, only: [:show, :edit, :update, :destroy]

    def index
      @stores = current_business_admin.stores
                          .where(status: "active")
                          .where.not(latitude: nil, longitude: nil)
    end

    def new
      @store = Store.new
    end

    def create
      @store = current_business_admin.stores.build(store_params)
      password = params[:store_manager_password]
      password_confirmation = params[:store_manager_password_confirmation]

      begin
        ActiveRecord::Base.transaction do
          unless @store.valid?
            raise ActiveRecord::RecordInvalid.new(@store)
          end

          store_manager = StoreManager.new(
            email: @store.email,
            password: password,
            password_confirmation: password_confirmation,
            store: @store,
            receive_notifications: false

          )

          unless store_manager.valid?
            raise ActiveRecord::RecordInvalid.new(store_manager)
          end

          @store.save!
          store_manager.save!

          recipient_email = params[:store_manager_recipient_email].presence || @store.email
          StoreMailer.send_credentials(@store, store_manager, password, recipient_email).deliver_now

          flash[:notice] = "Store successfully created. Credentials sent to #{recipient_email}."
          redirect_to dashboard_business_admins_store_path(@store)
        end
      rescue ActiveRecord::RecordInvalid => e
        flash.now[:alert] = "Error creating the store or manager: #{e.record.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if @store.destroy
        flash[:notice] = "Store successfully deleted."
      else
        flash[:alert] = "Error deleting the store."
      end
      redirect_to business_admins_stores_path, allow_other_host: true    
    end

    private

    def store_params
      params.require(:store).permit(
        :name, :email, :phone, :address, :zip_code, :status,
        :receive_notifications, :description, :business_number,
        :cuisine_id, :category_id, :logo
      )
    end

    def set_store
      @store = current_business_admin.stores.friendly.find(params[:id])
    end

    def after_update_path
      business_admins_store_url(@store)
    end
  end
end