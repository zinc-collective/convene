module AuthHelpers
  # Borrowed from https://github.com/mikker/passwordless/blob/master/lib/passwordless/test_helpers.rb, which
  # is not released yet.
  def sign_in(person)
    return if person.nil?
    session = Passwordless::Session.create!(authenticatable: person, user_agent: "TestAgent", remote_addr: "unknown")
    get Passwordless::Engine.routes.url_helpers.token_sign_in_path(session.token)
  end
end

RSpec.configure do |config|
  config.include AuthHelpers
end
