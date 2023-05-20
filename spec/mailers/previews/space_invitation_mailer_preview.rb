# Preview at http://localhost:3000/rails/mailers/space_invitation_mailer

class SpaceInvitationMailerPreview < ActionMailer::Preview
  def space_invitation_email
    space = Space.find_by(slug: "system-test")
    invitation = space.invitations.pending.last || FactoryBot.create(:invitation, space: space)
    SpaceInvitationMailer.space_invitation_email(invitation, space.name)
  end
end
