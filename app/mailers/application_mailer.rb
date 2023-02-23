class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("EMAIL_DEFAULT_FROM", "from@example.com")
  prepend_view_path "app/furniture"

  layout "mailer"
end
