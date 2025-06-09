ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"
require "bcrypt"

# Recarrega as rotas para garantir que estão atualizadas
Rails.application.routes.default_url_options[:host] = 'localhost:3000'

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
    # Inclui os helpers do Devise para facilitar o login nos testes
    include Devise::Test::IntegrationHelpers

    # Inclui os helpers do Warden, se necessário
    include Warden::Test::Helpers
    Warden.test_mode!

    # Inclui os helpers de rotas do Rails
    include Rails.application.routes.url_helpers

    # Adicione mais métodos auxiliares para serem usados em todos os testes aqui...
  end
end

Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 52.133,
      'longitude'    => -106.634,
      'address'      => "Default address",
      'state'        => "Saskatchewan",
      'state_code'   => "SK",
      'country'      => "Canada",
      'country_code' => "CA"
    }
  ]
)