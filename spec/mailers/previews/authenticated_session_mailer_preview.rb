# Preview all emails at http://localhost:3000/rails/mailers/authenticated_session_mailer
class AuthenticatedSessionMailerPreview < ActionMailer::Preview
  def one_time_password_email
    space = Space.find_by(slug: 'system-test')
    authentication_method = AuthenticationMethod.find_or_create_by!(contact_location: 'space-member@example.com', contact_method: 'email')
    AuthenticatedSessionMailer.one_time_password_email(authentication_method, space)
  end
end
