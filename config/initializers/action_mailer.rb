Rails.application.reloader.to_prepare do
  if ENV["SMTP_ADDRESS"]
    ActionMailer::Base.smtp_settings = {
      address: ENV["SMTP_ADDRESS"],
      domain: ENV["SMTP_DOMAIN"],
      port: ENV["SMTP_PORT"].to_i,
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"],
      authentication: ENV["SMTP_AUTHENTICATION"]&.to_sym,
      tls: ENV.fetch("SMTP_ENABLE_TLS", true) != "false",
      enable_starttls_auto: ENV.fetch("SMTP_ENABLE_TLS", true) != "false"
    }.compact

    ActionMailer::Base.delivery_method = :smtp
  end

  if ENV["APP_ROOT_URL"]
    root_uri = URI.parse(ENV["APP_ROOT_URL"])
    ActionMailer::Base.default_url_options[:host] = root_uri.host
    ActionMailer::Base.default_url_options[:port] = root_uri.port if root_uri.port != root_uri.default_port
    ActionMailer::Base.default_url_options[:protocol] = root_uri.scheme
  end
end
