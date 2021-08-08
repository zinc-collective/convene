class Rsvp
  include ActiveModel::Model

  attr_accessor :invitation
  delegate :space, to: :invitation

  def update(attributes)
    invitation.update(status: attributes[:status])
    person = Person.create(name: invitation.name, email: invitation.email)
    person.space_memberships.create(space: invitation.space)
    authentication_method = person.authentication_methods.create(contact_method: :email, contact_location: invitation.email)

    authentication_method.send_one_time_password!(invitation.space)
  end

  def persisted?
    true
  end
end