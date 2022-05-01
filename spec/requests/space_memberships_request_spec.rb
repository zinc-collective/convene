# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/space_memberships/', type: :request do
  path '/space_memberships' do
    include ApiHelpers::Path
    post 'Creates a SpaceMembership' do
      tags 'SpaceMembership'
      produces 'application/json'
      consumes 'application/json'
      security [api_key: []]

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          space_membership: {
            type: :object,
            properties: {
              member_id: { type: :string, example: 'a-uuid-for-a-person' },
              space_id: { type: :string, example: 'a-uuid-for-space' }
            },
            required: %w[person_id space_id]
          }
        },
        required: ['space_membership']
      }
      let(:api_key) { ENV['OPERATOR_API_KEY'] }
      let(:Authorization) { encode_authorization_token(api_key) }
      let(:body) { { space_membership: attributes } }
      let(:person) { create(:person) }
      let(:space) { create(:space) }

      response '201', 'Space Membership Created' do
        let(:attributes) { attributes_for(:space_membership, member_id: person.id, space_id: space.id) }
        run_test! do |response|
          data = response_data(response)

          space_membership = SpaceMembership.find(data[:space_membership][:id])
          expect(space_membership).to be_present
          expect(space_membership.member).to be_present
          expect(space_membership.member).to eq(person)

          expect(data[:space_membership])
            .to eq(id: space_membership.id,
                   space: { id: space.id },
                   member: { id: person.id })
        end
      end

      response '422', 'Member already exists in Space' do
        before { create(:space_membership, member: person, space: space) }
        let(:attributes) { attributes_for(:space_membership, member_id: person.id, space_id: space.id) }

        run_test!
      end
    end
  end
end