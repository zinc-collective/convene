# frozen_string_literal: true

class Rsvp
  include ActiveModel::Model
  include WithinLocation
  location(parent: :invitation)

  attr_accessor :invitation

  delegate :space, to: :invitation

  def update(attributes)
    return false if invitation.expired?

    if %w[ignored pending].include?(attributes[:status])
      return invitation.update(status: attributes[:status])
    end

    person = Person.create_with(name: invitation.name).find_or_create_by(email: invitation.email)

    authentication_method = person.authentication_methods.find_or_create_by(contact_method: :email,
      contact_location: invitation.email)

    authentication_method.verify!(attributes[:one_time_password]) if attributes[:one_time_password]
    if authentication_method.confirmed?
      invitation.update(status: attributes[:status])

      person.memberships.create(space: space, invitation: invitation)
    else
      authentication_method.send_one_time_password!(space)
      false
    end
  end

  # Overload `persisted?` so the Rails url build won't try to pluralize rsvps.
  # @todo - Do we want to switch to `resources` so we don't need this?
  def persisted?
    true
  end
end
