class SpaceInvitationMailer < ApplicationMailer
  def space_invitation_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email)
  end
end
