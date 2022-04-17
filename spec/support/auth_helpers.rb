module AuthHelpers
  def sign_in(space, person)
    return if person.nil?

    authentication_method = person.authentication_methods
      .create_with(contact_location: person.email)
      .find_or_create_by(contact_method: :email)

    authentication_method.bump_one_time_password!

    post(space_authenticated_session_path(space),
         params: { authenticated_session: {
           authentication_method_id: authentication_method.id,
           one_time_password: authentication_method.one_time_password
         } })
  end

  def sign_in_as_member(space)
    member = space.members.first
    raise ArgumentError "Couldn't find a member for space #{space.slug}" unless member.present?

    sign_in(space, member)
  end

  def authorization_headers(token = ENV['OPERATOR_API_KEY'])
    {
      'HTTP_AUTHORIZATION' =>
        ActionController::HttpAuthentication::Token.encode_credentials(token)
    }
  end
end
