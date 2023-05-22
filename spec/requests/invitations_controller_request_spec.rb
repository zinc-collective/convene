# frozen_string_literal: true

require "rails_helper"

RSpec.describe InvitationsController do
  describe "#create" do
    let(:mail) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }
    let(:membership) { create(:membership) }
    let(:space) { membership.space }
    let(:member) { membership.member }
    let(:invitation) {
      space.invitations.find_by(name: "foobar",
        email: "foobar@example.com")
    }

    before do
      allow(SpaceInvitationMailer).to receive(:space_invitation_email)
        .and_return(mail)

      sign_in(space, member)

      post space_invitations_path(space), params: {
        invitation: {name: "foobar", email: "foobar@example.com"}
      }
    end

    it "creates and sends an invitation for a space" do
      expect(invitation).to be_present
      expect(invitation.status).to eq("pending")

      expect(response).to redirect_to([space, :invitations])
      expect(flash[:notice]).to eql(I18n.t("invitations.create.success",
        invitee_email: invitation.email,
        invitee_name: invitation.name))

      expect(SpaceInvitationMailer).to have_received(:space_invitation_email)
        .with(invitation)
      expect(mail).to have_received(:deliver_later)
    end

    it "re-renders the new invitation form" do
      membership = create(:membership)
      space = membership.space
      member = membership.member

      sign_in(space, member)

      post "/spaces/#{space.slug}/invitations", params: {
        invitation: {name: "foobar"}
      }
      expect(assigns(:invitation)).not_to be_valid
      expect(response).to render_template(:index)
    end

    it "doesn't allow non-space-members to create invitations" do
      space = create(:space)
      non_member = create(:person)

      sign_in(space, non_member)

      post space_invitations_path(space), params: {
        invitation: {name: "foobar", email: "foobar@example.com"}
      }

      expect(response).to be_not_found
      expect(space.invitations).to be_empty
    end
  end

  describe "#destroy" do
    it "Revokes the Invitation" do
      membership = create(:membership)
      space = membership.space
      member = membership.member
      invitation = create(:invitation, space: space)

      sign_in(space, member)

      delete polymorphic_path([space, invitation])
      expect(response).to redirect_to([space, :invitations])

      expect(invitation.reload).to be_revoked
    end
  end
end
