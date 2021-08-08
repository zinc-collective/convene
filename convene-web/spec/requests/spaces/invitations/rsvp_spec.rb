# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/invitations/:invitation_id/rsvp', type: :request do
  # @todo We need to build the flow fo accepting an invitation out
  describe 'GET /spaces/:space_id/invitations/:invitation_id/rsvp' do
    context 'as a guest' do
      it 'Does not require them to sign in' do
        invitation = FactoryBot.create(:invitation)

        get space_invitation_rsvp_path(invitation.space, invitation)

        expect(response).to be_ok
        expect(response).to render_template(:show)
        expect(assigns(:invitation)).to eql(invitation)
      end
    end

    context 'as a neighbor' do
    end

    context 'as a space member' do
    end
  end

  describe 'PUT /spaces/:space_id/invitations/:invitation_id/rsvp' do
    context 'as a guest' do
      it 'registers them when they accept the invitation' do
        invitation = FactoryBot.create(:invitation)

        expect do
          put space_invitation_rsvp_path(invitation.space, invitation), params: { rsvp: { status: :accepted }}
        end.to have_enqueued_mail(AuthenticatedSessionMailer, :one_time_password_email)

        person = Person.find_by!(email: invitation.email)

        expect(invitation.reload).to be_accepted

        expect(response).to redirect_to(new_space_authenticated_session_path(invitation.space, params: { authenticated_session: { contact_method: :email, contact_location: person.email }}))
        expect(person.space_memberships.find_by(space: invitation.space)).to be_present
        expect(person.authentication_methods.find_by!(contact_method: :email, contact_location: invitation.email).confirmed_at).to be_blank
      end
    end
  end
end
