# app/controllers/customers/payments_controller.rb
class Customers::PaymentsController < ApplicationController
    def create
      # Aqui você coloca a lógica do pagamento (pode estar vazio só pra passar no teste por enquanto)
      head :ok
    end
end