class SpaceInvitationMailer < ApplicationMailer
  def space_invitation_email(invitation)
    @invitation = invitation
    @space = invitation.space
    mail(
      to: @invitation.email,
      from: "#{@invitation.invitor_display_name} (via #{@space.name}) #{ENV.fetch("EMAIL_DEFAULT_FROM")}",
      subject: "#{@invitation.invitor_display_name} invited you to #{@space.name}"
    )
  end
end
