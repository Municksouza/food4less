require "active_support/core_ext/integer/time"

Rails.application.configure do
  # === URLs ===
  config.action_mailer.default_url_options = {
    host: "getfood4less.ca",
    protocol: "https"
  }
  config.action_mailer.default_options = {
    from: "admin@getfood4less.ca"
  }
  config.hosts << "getfood4less.ca"

  # === Rails defaults ===
  config.eager_load = true
  config.consider_all_requests_local = false
  config.enable_reloading = false

  # === Caching ===
  config.action_controller.perform_caching = true
  config.cache_store = :solid_cache_store
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  # === Asset management ===
  config.assets.compile = false
  config.assets.digest = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # === File storage ===
  config.active_storage.service = :cloudinary

  # === SSL and security ===
  config.assume_ssl = true
  config.force_ssl = true

  # === Logging ===
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  # === Job queue ===
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # === Mailer (SendGrid) ===
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.sendgrid.net",
    port:                 587,
    domain:               "getfood4less.ca",
    user_name:            "apikey",
    password:             ENV["SENDGRID_API_KEY"],
    authentication:       :plain,
    enable_starttls_auto: true
  }

  # === Internationalization ===
  config.i18n.fallbacks = true

  # === Compression and optimization ===
  config.middleware.use Rack::Deflater

  # === Optional Debug Cache Logging ===
  if defined?(ActiveSupport::Notifications)
    ActiveSupport::Notifications.subscribe("cache_read.active_support") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      Rails.logger.debug "[CACHE READ] #{event.payload[:key]}"
    end

    ActiveSupport::Notifications.subscribe("cache_write.active_support") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      Rails.logger.debug "[CACHE WRITE] #{event.payload[:key]}"
    end
  end
end