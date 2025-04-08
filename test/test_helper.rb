ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"
require "bcrypt"

# Recarrega as rotas para garantir que estão atualizadas
Rails.application.routes.default_url_options[:host] = 'localhost:3000'
include Rails.application.routes.url_helpers

# Configuração do Devise para testes
# Devise.setup do |config|
#   config.router_name = :main_app if defined?(main_app)
# end

module ActiveSupport
  class TestCase
    # Executa os testes em paralelo com o número de processadores disponíveis
    parallelize(workers: :number_of_processors)

    # Carrega todos os fixtures em test/fixtures/*.yml para todos os testes
    fixtures :all

    # Inclui os helpers do Devise para facilitar o login nos testes
    include Devise::Test::IntegrationHelpers

    # Inclui os helpers do Warden, se necessário
    include Warden::Test::Helpers
    Warden.test_mode!

    # Adicione mais métodos auxiliares para serem usados em todos os testes aqui...
  end
end