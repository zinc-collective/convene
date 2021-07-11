# Preview at http://localhost:3000/rails/mailers/space_invitation_mailer

class SpaceInvitationMailerPreview < ActionMailer::Preview
  def space_invitation_email
    space = Space.find_by(slug: 'system-test')
    invitation = space.invitations.last || FactoryBot.create(:invitation, space: space)
    SpaceInvitationMailer.space_invitation_email(invitation)
  end
end
