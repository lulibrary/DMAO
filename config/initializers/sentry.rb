Raven.configure do |config|
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.dsn = Rails.application.config_for(:sentry)["dsn"]
  config.environments = Rails.application.config_for(:sentry)["environments"]
end