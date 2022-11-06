# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "/memberships/", type: :request do
  path "/memberships" do
    include ApiHelpers::Path
    post "Creates a Membership" do
      tags "Membership"
      produces "application/json"
      consumes "application/json"
      security [api_key: []]

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          membership: {
            type: :object,
            properties: {
              member_id: {type: :string, example: "a-uuid-for-a-person"},
              space_id: {type: :string, example: "a-uuid-for-space"}
            },
            required: %w[person_id space_id]
          }
        },
        required: ["membership"]
      }
      let(:api_key) { ENV["OPERATOR_API_KEY"] }
      let(:Authorization) { encode_authorization_token(api_key) }
      let(:body) { {membership: attributes} }
      let(:person) { create(:person) }
      let(:space) { create(:space) }

      response "201", "Space Membership Created" do
        let(:attributes) { attributes_for(:membership, member_id: person.id, space_id: space.id) }
        run_test! do |response|
          data = response_data(response)

          membership = Membership.find(data[:membership][:id])
          expect(membership).to be_present
          expect(membership.member).to be_present
          expect(membership.member).to eq(person)

          expect(data[:membership])
            .to eq(id: membership.id,
              space: {id: space.id},
              member: {id: person.id})
        end
      end

      response "422", "Member already exists in Space" do
        before { create(:membership, member: person, space: space) }

        let(:attributes) { attributes_for(:membership, member_id: person.id, space_id: space.id) }

        run_test!
      end

      response "422", "Required Attributes are not included" do
        let(:attributes) { attributes_for(:membership, member_id: nil, space_id: nil) }

        run_test!
      end
    end
  end

  describe "DELETE /membership/:id" do
    subject(:perform_request) { delete polymorphic_path([membership.space, membership]) }

    let(:space) { create(:space, :with_members) }
    let(:membership) { create(:membership, space: space) }

    before do
      sign_in_as_member(space)
    end

    it "revokes the membership" do
      perform_request

      expect(flash[:notice]).to eq(I18n.t("memberships.destroy.success"))

      expect(membership.reload).to be_revoked
    end

    context "when not logged in as a member of the space" do
      let(:membership) { create(:membership) }

      it "does not delete the membership" do
        expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound)
        expect(membership.reload).to be_present
        expect(membership.reload).not_to be_revoked
      end
    end
  end
end
