# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/authentication_methods/', type: :request do
  path '/authentication_methods' do
    include ApiHelpers::Path

    post 'Creates an AuthenticationMethod' do
      tags 'AuthenticationMethod'
      produces 'application/json'
      consumes 'application/json'
      security [api_key: []]

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          authentication_method: {
            type: :object,
            properties: {
              contact_method: { type: :string, example: 'email' },
              contact_location: { type: :string, example: 'your-email@example.com' }
            },
            required: %w[contact_method contact_location]
          }
        },
        required: ['authentication_method']
      }
      let(:person) { create(:person) }
      let(:api_key) { ENV['OPERATOR_API_KEY'] }
      let(:Authorization) { encode_authorization_token(api_key) }
      let(:body) { { authentication_method: attributes } }

      response '201', 'authentication method created' do
        let(:attributes) { attributes_for(:authentication_method, person: person) }

        run_test! do |response|
          data = response_data(response)

          authentication_method = AuthenticationMethod.find(data[:authentication_method][:id])
          expect(authentication_method).to be_present
          expect(authentication_method.person).to be_present
          expect(authentication_method.person).to eq(person)

          expect(data[:authentication_method])
            .to eq(id: authentication_method.id,
                   contact_method: attributes[:contact_method].to_s,
                   contact_location: attributes[:contact_location],
                   person: { id: person.id })
        end
      end
      response '422', 'authentication method invalid' do
        let(:existing_authentication_method) { create(:authentication_method) }
        let(:attributes) do
          {
            contact_method: existing_authentication_method.contact_method,
            contact_location: existing_authentication_method.contact_location
          }
        end

        run_test! do |response|
          expected_error = ActiveModel::Error.new(AuthenticationMethod.new, :contact_location, :taken)

          expect(response_data(response)[:errors])
            .to include(
              code: expected_error.type.to_s,
              title: expected_error.full_message,
              detail: expected_error.message,
              source: { pointer: '/authentication_method/contact_location' }
            )
        end
      end
    end
  end
end
