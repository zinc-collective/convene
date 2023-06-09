class ApplicationMailer < ActionMailer::Base
  DEFAULT_FROM = ENV.fetch("EMAIL_DEFAULT_FROM", "convene-support@example.com")

  default from: DEFAULT_FROM
  prepend_view_path "app/furniture"

  layout "mailer"
end
