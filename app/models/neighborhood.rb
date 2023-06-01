# frozen_string_literal: true

class Neighborhood
  def spaces
    Space.all
  end

  def email_configured?
    if email_configuration[:address] == "localhost"
      email_configuration.except(:user_name, :password)
    else
      email_configuration
    end.values.none?(:nil?) &&
      ENV["APP_ROOT_URL"].present? &&
      ENV["EMAIL_DEFAULT_FROM"].present?
  end

  def operators
    Person.where(operator: true)
  end

  def url
    ENV.fetch("APP_ROOT_URL")
  end

  def name
    ENV.fetch("NEIGHBORHOOD_NAME", "Convene")
  end

  def tagline
    ENV.fetch("NEIGHBORHOOD_TAGLINE", "Space to Work, Play, or Simply Be")
  end

  def email_configuration
    {
      address: ENV["SMTP_ADDRESS"],
      domain: ENV["SMTP_DOMAIN"],
      port: ENV["SMTP_PORT"].to_i,
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"],
      authentication: ENV["SMTP_AUTHENTICATION"]&.to_sym,
      tls: ENV.fetch("SMTP_ENABLE_TLS", true) != "false",
      enable_starttls_auto: ENV.fetch("SMTP_ENABLE_TLS", true) != "false"
    }
  end
end
