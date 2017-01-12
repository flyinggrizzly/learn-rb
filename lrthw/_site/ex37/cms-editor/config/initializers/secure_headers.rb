# Configs for secureheader gem https://github.com/twitter/secureheaders
::SecureHeaders::Configuration.configure do |config|
  config.hsts = { max_age: 631_138_519, include_subdomains: false }
  config.x_frame_options = 'SAMEORIGIN'
  # set the :mode option to false to use "warning only" mode
  config.x_xss_protection = { value: 1, mode: 'block' }
  config.x_content_type_options = 'nosniff'
  config.x_download_options = 'noopen'
  config.x_permitted_cross_domain_policies = 'none'
  # Content Security Policy - override default
  config.csp = {
    default_src: 'self http://www.bath.ac.uk inline',
    font_src: 'http://fast.fonts.net https://fast.fonts.net',
    script_src: 'https://www.google-analytics.com http://www.google-analytics.com'
  }
end

# For local dev and staging allow eval() - because rack-mini-profiler widget
# uses jquery.tmpl.js which runs eval()
if Rails.env == 'development' || Rails.env == 'staging'
  ::SecureHeaders::Configuration.configure do |config|
    config.csp = {
      default_src: 'self http://www.bath.ac.uk inline eval'
    }
  end
end
