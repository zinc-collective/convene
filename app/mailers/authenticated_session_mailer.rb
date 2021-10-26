class AuthenticatedSessionMailer < ApplicationMailer
  def one_time_password_email(authentication_method, space)
    @authentication_method = authentication_method
    @space = space
    mail(to: authentication_method.contact_location, subject: "Your One Time Password")
  end
end
