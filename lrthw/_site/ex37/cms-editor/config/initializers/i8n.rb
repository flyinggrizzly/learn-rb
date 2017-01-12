if Rails.env == 'development'
  Rails.application.config.i18n.callbacks do
    I18n.reload!
  end
end