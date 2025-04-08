class StoreMailer < ApplicationMailer
  default from: 'no-reply@food4less.com'

  # Método para enviar as credenciais do Store Manager
  #
  # @param store [Store] a loja recém-criada
  # @param store_manager [StoreManager] o usuário criado para o gerente da loja
  # @param generated_password [String] a senha gerada aleatoriamente
  # @param recipient_email [String] o e-mail para o qual as credenciais serão enviadas
  def send_credentials(store, store_manager, password, recipient_email)
    @store = store
    @store_manager = store_manager
    @password = password
  
    mail(to: recipient_email, subject: "Store Manager Credentials")
  end
end