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

        # @todo Make sure the response includes the serialized person

        authentication_method =
          AuthenticationMethod.find_by(
            params.slice(:contact_method, :contact_location)
          )

        expect(authentication_method).to be_present
        expect(authentication_method.person).to be_present
        expect(authentication_method.person).to eq(person)
      end
    end
  end
end
