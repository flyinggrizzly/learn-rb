Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = true

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  ## Logging config
  # General settings
  config.autoflush_log = true
  config.lograge.enabled = true
  config.colorize_logging = false

  # Override default logging. Send logs to file, rotating at 50MiB and keeping 10 files
  # See http://ruby-doc.org/stdlib-2.0.0/libdoc/logger/rdoc/Logger.html#method-c-new
  default_logger = ActiveSupport::Logger.new('log/production.log', 10, 50 * 1024 * 1024)
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
  config.action_controller.asset_host = 'www.bath.ac.uk'

  # URL prefix for preview and live pages
  config.x.preview_url = 'http://preview.bath.ac.uk'
  config.x.published_url = 'http://www.bath.ac.uk'
end
