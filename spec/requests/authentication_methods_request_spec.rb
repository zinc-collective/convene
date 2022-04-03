# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/authentication_methods/', type: :request do
  include ActiveJob::TestHelper

  describe 'POST /authentication_methods/' do
    context 'as an Operator using the API' do
      it 'creates an AuthenticationMethod' do
        person = create(:person)
        params = attributes_for(:authentication_method, person: person)
        post authentication_methods_path,
             params: { authentication_method: params },
             headers: authorization_headers,
             as: :json

        authentication_method = AuthenticationMethod.find_by!(
          params.slice(:contact_method, :contact_location)
        )

        expect(authentication_method).to be_present
        expect(authentication_method.person).to be_present
        expect(authentication_method.person).to eq(person)

        expect(json_response[:authentication_method])
          .to eq({ id: authentication_method.id,
                   contact_method: params[:contact_method].to_s,
                   contact_location: params[:contact_location],
                   person: { id: person.id } })
      end

      it 'returns validation errors when the authentication method cannot be saved' do
        existing_authentication_method = create(:authentication_method)

        post authentication_methods_path,
             params: { authentication_method: {
               contact_method: existing_authentication_method.contact_method,
               contact_location: existing_authentication_method.contact_location
             } },
             headers: authorization_headers,
             as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors]).to eq(
          [{
            title: I18n.t('authentication_methods.create.failure'),
            detail: 'Contact location has already been taken'
          }]
        )
      end

      def json_response
        @json_response ||= JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
