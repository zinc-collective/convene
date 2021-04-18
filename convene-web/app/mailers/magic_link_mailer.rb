class MagicLinkMailer < ApplicationMailer
  default from: Passwordless.default_from_address

  # Based on Passwordless' default Mailer implementation
  def magic_link(session, request)
    @magic_link = people.token_sign_in_url(session.token, host: request.host)
    email = session.authenticatable.class.passwordless_email_field
    mail(
      to: session.authenticatable.send(email),
      subject: I18n.t("passwordless.mailer.subject")
    )
  end
end
