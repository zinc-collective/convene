class AuthenticatedSessionMailer < ApplicationMailer
  def one_time_password_email(authentication_method)
    @authentication_method = authentication_method
    mail(to: authentication_method.contact_location, subject: "Your One Time Password")
  end
end
