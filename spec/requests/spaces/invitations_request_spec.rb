# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/invitations', type: :request do
  describe 'POST' do
    it 'creates and sends an invitation for a space' do
      mail = double(deliver_later: true)
      allow(SpaceInvitationMailer).to receive(:space_invitation_email)
        .and_return(mail)

      membership = create(:membership)
      space = membership.space
      member = membership.member

      sign_in(space, member)

      post "/spaces/#{space.slug}/invitations", params: {
        invitation: { name: 'foobar', email: 'foobar@example.com' }
      }

      invitation = space.invitations.find_by(name: 'foobar',
                                             email: 'foobar@example.com')

      expect(invitation).to be_present
      expect(invitation.status).to eq('pending')

    expect(response).to redirect_to(space_memberships_path(space))
    expect(flash[:notice]).to eql(I18n.t('invitations.create.success',
                                         invitee_email: invitation.email,
                                         invitee_name: invitation.name))

      expect(SpaceInvitationMailer).to have_received(:space_invitation_email)
        .with(invitation)
      expect(mail).to have_received(:deliver_later)
    end

    it "doesn't allow non-space-members to create invitations" do
      space = create(:space)
      non_member = create(:person)

      sign_in(space, non_member)

      post "/spaces/#{space.slug}/invitations", params: {
        invitation: { name: 'foobar', email: 'foobar@example.com' }
      }

      expect(space.invitations).to be_empty
    end
  end

  describe 'DELETE /:invitation_id' do
    it 'Revokes the Invitation' do
      membership = create(:membership)
      space = membership.space
      member = membership.member
      invitation = create(:invitation, space: space)

      sign_in(space, member)

      delete polymorphic_path([space, invitation])

      expect(invitation.reload).to be_revoked
    end
  end
end
