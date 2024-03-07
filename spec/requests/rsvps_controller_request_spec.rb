# frozen_string_literal: true

require "rails_helper"

RSpec.describe RsvpsController do
  let(:space) { invitation.space }
  let(:neighbor) { create(:neighbor) }
  let(:invitation) { create(:invitation) }

  describe "#show" do
    it "does not require people to sign in" do
      get space_invitation_rsvp_path(space, invitation)

      expect(response).to be_ok
      expect(response).to render_template(:show)
      expect(assigns(:invitation)).to eql(invitation)
    end
  end

  describe "#update" do
    subject(:request) do
      put space_invitation_rsvp_path(space, invitation),
        params: {rsvp: rsvp_params}
    end

    let(:rsvp_params) { {} }

    context "when a guest" do
      context "without the one-time-code" do
        let(:rsvp_params) { {status: :accepted} }

        it "doesnt complete the invitation" do # rubocop:disable RSpec/ExampleLength
          expect { request }.to have_enqueued_mail(
            AuthenticatedSessionMailer, :one_time_password_email
          )

          person = Person.find_by!(email: invitation.email)

          expect(invitation.reload).not_to be_accepted
          expect(person.memberships
              .find_by(space: space)).not_to be_present

          authentication_method = person
            .authentication_methods
            .find_by!(contact_method: :email,
              contact_location: invitation.email)

          expect(authentication_method.confirmed_at).to be_blank
          expect(response).to render_template(:update)
        end
      end

      context "when they include the one-time code proving they are who they say they are" do
        let(:person) { create(:person, email: invitation.email) }
        let(:authentication_method) { create(:authentication_method, person: person) }
        let(:rsvp_params) do
          {status: :accepted, one_time_password: authentication_method.one_time_password}
        end

        it "completes the invitation and confirms their authentication method" do # rubocop:disable RSpec/ExampleLength
          expect { request }.not_to have_enqueued_mail(
            AuthenticatedSessionMailer, :one_time_password_email
          )

          person = Person.find_by!(email: invitation.email)

          expect(invitation.reload).to be_accepted

          membership = person.memberships.find_by(space: space)
          expect(membership).to be_present
          expect(membership.invitation).to eq(invitation)
          expect(invitation.membership).to eq(membership)

          authentication_method = person
            .authentication_methods
            .find_by!(contact_method: :email,
              contact_location: invitation.email)

          expect(authentication_method).to be_confirmed
          expect(response).to redirect_to(space)
          expect(flash[:notice]).to eq(I18n.t("rsvps.update.success", space_name: space.name))
        end
      end

      context "when the invitation has expired" do
        let(:rsvp_params) { {status: :accepted} }

        before do
          invitation.update!(created_at: invitation.created_at - 1.year)
        end

        it "does not allow accepting the invitation" do
          expect { request }.not_to have_enqueued_mail(
            AuthenticatedSessionMailer, :one_time_password_email
          )

          expect(Person.where(email: invitation.email)).not_to exist

          expect(invitation.reload).not_to be_accepted
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:update)
        end
      end
    end

    context "when their email is already registered" do
      let(:rsvp_params) { {status: :accepted} }
      let!(:neighbor) { create(:person, email: invitation.email) }

      before { create(:authentication_method, person: neighbor) }

      it "does not accept the invitation until they sign in" do
        expect { request }.to have_enqueued_mail(
          AuthenticatedSessionMailer, :one_time_password_email
        ).with(neighbor.authentication_methods.first, space)

        expect(invitation.reload).not_to be_accepted
        expect(neighbor.memberships
          .find_by(space: space)).not_to be_present
      end
    end

    context "when ignoring an invitation" do
      let(:rsvp_params) { {status: :ignored} }

      it "doesnt complete the invitation" do
        expect { request }.to change { invitation.reload.status }.to("ignored")
        expect(response).to render_template(:show)
      end
    end

    context "when un-ignoring an invitation" do
      let(:invitation) { create(:invitation, status: "ignored") }
      let(:rsvp_params) { {status: :pending} }

      it "doesnt complete the invitation" do
        expect { request }.to change { invitation.reload.status }.to("pending")
        expect(response).to render_template(:show)
      end
    end
  end
end
