class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("EMAIL_DEFAULT_FROM", "from@example.com")
  layout "mailer"
end
