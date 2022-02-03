# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/invitations/:invitation_id/rsvp', type: :request do
  let(:space) { invitation.space }
  let(:neighbor) { create(:neighbor) }
  let(:invitation) { create(:invitation) }
  describe 'GET /spaces/:space_id/invitations/:invitation_id/rsvp' do
    context 'as a guest' do
      it 'Does not require them to sign in' do
        get space_invitation_rsvp_path(space, invitation)

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
      context 'whose email is unique within the system' do
        it 'registers them when they accept the invitation' do
          expect do
            put space_invitation_rsvp_path(space, invitation),
                params: { rsvp: { status: :accepted } }
          end.to have_enqueued_mail(AuthenticatedSessionMailer, :one_time_password_email)

          person = Person.find_by!(email: invitation.email)

          expect(invitation.reload).to be_accepted

          expect(response).to redirect_to(
            new_space_authenticated_session_path(space,
                                                 params: {
                                                   authenticated_session:
                                                  {
                                                    contact_method: :email,
                                                    contact_location: person.email
                                                  }
                                                 })
          )
          expect(person.space_memberships
              .find_by(space: space)).to be_present

          authentication_method = person
                                  .authentication_methods
                                  .find_by!(contact_method: :email,
                                            contact_location: invitation.email)

          expect(authentication_method.confirmed_at).to be_blank
        end
      end
    end

    context 'whose email is already registered' do
      let!(:neighbor) { create(:person, email: invitation.email) }
      let!(:authentication_method) do
        create(:authentication_method, person: neighbor)
      end

      it 'does not accept the invitation until they sign in' do
        expect do
          put space_invitation_rsvp_path(space, invitation),
              params: { rsvp: { status: :accepted } }
        end.to have_enqueued_mail(
          AuthenticatedSessionMailer, :one_time_password_email
        ).with(neighbor.authentication_methods.first, space)

        expect(response).to redirect_to(
          new_space_authenticated_session_path(space,
                                               params: {
                                                 authenticated_session:
                                                {
                                                  contact_method: :email,
                                                  contact_location: neighbor.email
                                                }
                                               })
        )

        # @todo - can we assert there's a flash message?
        # @todo - Maybe we want to require signing in when showing the
        #         invitation if it's for a  person who is already registered?

        expect(invitation.reload).not_to be_accepted
        expect(neighbor.space_memberships
          .find_by(space: space)).not_to be_present
      end
    end
  end
end
