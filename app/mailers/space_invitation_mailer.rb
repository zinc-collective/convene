class SpaceInvitationMailer < ApplicationMailer
  def space_invitation_email(invitation)
    @invitation = invitation
    @space = invitation.space
    mail(
      to: @invitation.email,
      from: "#{@invitation.invitor_display_name} (via #{@space})",
      subject: "#{@invitation.invitor_display_name} invited you to #{@space}"
    )
  end
end
