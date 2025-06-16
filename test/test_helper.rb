ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"
require "bcrypt"
require "database_cleaner/active_record"
require "factory_bot_rails"

# Configura o host padrão para rotas
Rails.application.routes.default_url_options[:host] = 'localhost:3000'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    
    # Executa os testes em paralelo (número de workers baseados nos processadores disponíveis)
    parallelize(workers: :number_of_processors)

    # Inclui os helpers do Devise e Warden
    include Devise::Test::IntegrationHelpers
    include Warden::Test::Helpers
    Warden.test_mode!
    

    # Inclui os helpers das rotas
    include Rails.application.routes.url_helpers

    # Setup/teardown com gerenciamento de triggers e clean com DatabaseCleaner
    setup do
       Faker::UniqueGenerator.clear
      begin
        ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")
      rescue ActiveRecord::StatementInvalid => e
        puts "⚠️  Skipping SET session_replication_role: #{e.message}"
      end
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end

    teardown do
      begin
        ActiveRecord::Base.connection.execute("SET session_replication_role = origin;")
      rescue ActiveRecord::StatementInvalid => e
        puts "⚠️  Skipping RESET session_replication_role: #{e.message}"
      end
      DatabaseCleaner.clean
    end
  end
end


# Patch: Desabilita a integridade referencial no PostgreSQL sem exigir privilégios de superusuário
if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
  module ActiveRecord
    module ConnectionAdapters
      class PostgreSQLAdapter
        def disable_referential_integrity
          yield
        rescue ActiveRecord::StatementInvalid => e
          puts "⚠️  Skipping disable_referential_integrity because: #{e.message}"
          yield
        end
      end
    end
  end
end

# Configuração do Geocoder para ambiente de teste
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