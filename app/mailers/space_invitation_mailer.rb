class SpaceInvitationMailer < ApplicationMailer
  def space_invitation_email(invitation, space)
    @invitation = invitation
    @space = space
    mail(to: @invitation.email, subject: "You are invited to #{@space}")
  end
end
