# frozen_string_literal: true

# Serializes {AuthenticationMethod}s for programmatic consumption
class AuthenticationMethod::Serializer < ApplicationSerializer
  # @return [AuthenticationMethod]
  alias_method :authentication_method, :resource

  def to_json(*_args)
    super.merge(
      authentication_method: {
        id: authentication_method.id,
        contact_method: authentication_method.contact_method,
        contact_location: authentication_method.contact_location,
        person: {
          id: authentication_method.person.id
        }
      }
    )
  end
end
