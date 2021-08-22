# frozen_string_literal: true

class Rsvp
  include ActiveModel::Model

  attr_accessor :invitation
  delegate :space, to: :invitation

  def update(attributes)
    person = Person.create_with(name: invitation.name).find_or_create_by(email: invitation.email)

    authentication_method = person.authentication_methods.find_or_create_by(contact_method: :email, contact_location: invitation.email)

    if person.previously_new_record?
      invitation.update(status: attributes[:status])

      person.space_memberships.create(space: invitation.space)
    end

    authentication_method.send_one_time_password!(invitation.space)
  end

  # Overload `persisted?` so the Rails url build won't try to pluralize rsvps.
  # @todo - Do we want to switch to `resources` so we don't need this?
  def persisted?
    true
  end
end
