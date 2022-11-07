require "rails_helper"

RSpec.describe AuthenticatedSession, type: :model do
  subject(:authenticated_session) do
    described_class.new(authentication_method: authentication_method,
      contact_method: contact_method,
      contact_location: contact_location,
      space: space,
      session: session,
      one_time_password: one_time_password)
  end

  let(:space) { FactoryBot.build_stubbed(:space, id: SecureRandom.uuid) }
  let(:authentication_method) { nil }
  let(:one_time_password) { nil }
  let(:contact_method) { nil }
  let(:contact_location) { nil }
  let(:session) { {} }

  describe "#save" do
    let(:authentication_method) do
      instance_double(AuthenticationMethod, send_one_time_password!: nil,
        verify?: nil, confirm!: nil)
    end

    context "when there is nothing to do" do
      it "does nothing" do
        expect(authenticated_session.save).to be(false)

        expect(session[:person_id]).to be_nil
        expect(authentication_method).not_to have_received(:send_one_time_password!)
        expect(authentication_method).not_to have_received(:verify?)
        expect(authentication_method).not_to have_received(:confirm!)
      end
    end

    context "when contact info is provided" do
      let(:contact_method) { :email }
      let(:contact_location) { "test@example.com" }

      context "but no one time password" do
        it "delivers a one time password to the authentication method" do
          authenticated_session.save

          expect(authentication_method).to have_received(:send_one_time_password!)
        end

        context "and the contact info is not related to an existing person" do
          let(:authentication_method) { nil }

          it "creates an authentication method and person from the provided contact info" do
            expect { authenticated_session.save }.to change { AuthenticationMethod.count }.by(1)

            authentication_method = AuthenticationMethod.last
            expect(authentication_method.person.email).to eql("test@example.com")
            expect(authentication_method.contact_method).to eql("email")
            expect(authentication_method.contact_location).to eql("test@example.com")
          end
        end

        context "and the contact info is for an existing person" do
          let(:authentication_method) { nil }

          before do
            FactoryBot.create(:authentication_method,
              contact_method: contact_method,
              contact_location: contact_location)
          end

          it "leverages the existing authentication method" do
            expect { authenticated_session.save }.not_to change { AuthenticationMethod.count }
          end
        end
      end

      context "and the correct otp is provided" do
        let(:one_time_password) { "123456" }

        before do
          allow(authentication_method).to receive(:verify?)
            .with(one_time_password).and_return(true)

          allow(authentication_method).to receive(:person)
            .and_return(FactoryBot.build_stubbed(:person, id: SecureRandom.uuid))
        end

        it "confirms the authentication method" do
          authenticated_session.save

          expect(authentication_method).to have_received(:confirm!)
        end

        it "populates the persons id in the session" do
          authenticated_session.save

          expect(session[:person_id]).to eql(authentication_method.person.id)
        end
      end
    end
  end
end
