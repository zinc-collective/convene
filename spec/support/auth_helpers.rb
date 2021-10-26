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
end
