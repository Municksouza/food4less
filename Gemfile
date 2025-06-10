source "https://rubygems.org"

# Use the stable version of Rails
gem "rails", "~> 8.0.1"
# Modern asset pipeline for Rails
gem "propshaft"
# Use PostgreSQL as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps
# gem "importmap-rails"
# Hotwire's SPA-like page accelerator
gem "turbo-rails"
# Hotwire's lightweight JavaScript framework
gem "stimulus-rails"
# Use Dart SASS for stylesheets
gem "dartsass-rails"
# Build JSON APIs easily
gem "jbuilder"

# Use Active Model's has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma
gem "thruster", require: false

# Use Active Storage variants for image processing
gem "image_processing", "~> 1.2"

gem "devise"             # User authentication
gem "pundit"             # Permission control
gem "simple_form"        # Easier forms
gem "stripe"             # Payments via Stripe
gem "paypal-sdk-rest", "~> 1.7" # Payments via PayPal
gem "prawn", "~> 2.5"    # Generate PDFs for invoices
gem "prawn-table", "~> 0.2.2" # Tables in PDFs
gem "faker"              # Generate fake data for tests
gem 'hotwire-rails'

group :development, :test do
  # Debugging tools for Rails applications
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities
  gem "brakeman", require: false

  # Ruby style guide enforcement
  gem "rubocop-rails-omakase", require: false
  gem "dotenv-rails"
end

group :development do
  # Use console on exception pages
  gem "web-console"
  gem "letter_opener" 
end

group :test do
  # System testing tools
  gem "capybara"
  gem "selenium-webdriver"
  gem 'database_cleaner-active_record'
end

gem "geocoder"
gem "jsbundling-rails", "~> 1.3"
gem "cssbundling-rails", "~> 1.3"
gem "chartkick", "~> 5.1"
gem "groupdate", "~> 6.5"
gem "minitest", "~> 5.25"
gem "open-uri-cached"
gem 'friendly_id', '~> 5.4.0'
gem "whenever", require: false
gem "mini_magick"
gem 'validates_zipcode'
gem 'redis', '~> 4.0' # Use Redis for caching and Action Cable
