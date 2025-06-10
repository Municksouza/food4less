ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"
require "bcrypt"

# Reload routes to ensure they are up to date
Rails.application.routes.default_url_options[:host] = 'localhost:3000'

# Devise configuration for tests
# Devise.setup do |config|
#   config.router_name = :main_app if defined?(main_app)
# end

module ActiveSupport
  class TestCase
    # Run tests in parallel with the number of available processors
    parallelize(workers: :number_of_processors)

    # Load all fixtures in test/fixtures/*.yml for all tests
    fixtures :all

    # Include Devise helpers for easier login in tests
    include Devise::Test::IntegrationHelpers

    # Include Warden helpers if needed
    include Warden::Test::Helpers
    Warden.test_mode!

    # Include Rails route helpers
    include Rails.application.routes.url_helpers
    setup do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end
      # Add more helper methods to be used by all tests here...
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
