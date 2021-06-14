class SpaceInvitationMailer < ApplicationMailer
  default from: "from@example.com"

  def space_invitation_email(person)
    @person = person
    mail(to: @person.email)
  end
end

