Sentry.init do |config|
  next unless ENV["SENTRY_DSN"]

  config.dsn = ENV["SENTRY_DSN"]
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  config.before_send = lambda do |event, hint|
    filter.filter(event.to_hash)
  end
end
