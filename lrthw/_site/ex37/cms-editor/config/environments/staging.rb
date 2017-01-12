Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  ## Logging config
  # General settings
  config.autoflush_log = true
  config.lograge.enabled = true
  config.colorize_logging = false

  # Override default logging. Send logs to file, rotating at 50MiB and keeping 10 files
  # See http://ruby-doc.org/stdlib-2.0.0/libdoc/logger/rdoc/Logger.html#method-c-new
  default_logger = ActiveSupport::Logger.new('log/staging.log', 10, 50 * 1024 * 1024)
  default_logger.formatter = ::Logger::Formatter.new
  default_logger.level = Logger::DEBUG
  config.logger = default_logger

  # Override default active_record logging. Send logs to file, rotating at 20MiB and keeping 5 files
  active_record_logger = ActiveSupport::Logger.new('log/active_record.log', 5, 20 * 1024 * 1024)
  active_record_logger.formatter = ::Logger::Formatter.new
  active_record_logger.level = Logger::DEBUG
  config.active_record.logger = active_record_logger

  # Override default rubycas-client logging. Send logs to file, rotating at 5MiB and keeping 5 files
  cas_logger = ActiveSupport::Logger.new('log/cas.log', 5, 5 * 1024 * 1024)
  cas_logger.formatter = ::Logger::Formatter.new
  cas_logger.level = Logger::DEBUG

  # CAS configuration
  CASClient::Frameworks::Rails::Filter.configure(
    cas_base_url: 'https://auth.bath.ac.uk/',
    logger: cas_logger
  )

  # Domain where the static assets are served from
  config.action_controller.asset_host = 'staging-beta.bath.ac.uk'

  # URL prefix for preview and live pages
  config.x.preview_url = 'http://staging-preview.bath.ac.uk'
  config.x.published_url = 'http://staging-beta.bath.ac.uk'
end
