class StoreMailer < ApplicationMailer
  default from: "no-reply@food4less.com"

  def send_credentials(store, store_manager, password)
    @store = store
    @store_manager = store_manager
    @password = password

    mail(to: @store_manager.email, subject: "Your Store Manager Account is Ready")
  end
end