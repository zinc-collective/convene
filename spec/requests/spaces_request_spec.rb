# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/', type: :request do
  include ActiveJob::TestHelper

  def authorization_headers(token)
    {
      'HTTP_AUTHORIZATION' =>
        ActionController::HttpAuthentication::Token.encode_credentials(token)
    }
  end
  describe 'DELETE /spaces/:space_slug/' do
    context 'as an Operator using the API' do
      it "deletes the space and all it's other bits" do
        SystemTestSpace.prepare

        space = Space.find_by(slug: 'system-test')
        delete space_path(space),
               headers: authorization_headers(ENV['OPERATOR_API_KEY']),
               as: :json

        perform_enqueued_jobs

        expect(space.rooms).to be_empty
        expect(space.utility_hookups).to be_empty
        expect(space.items).to be_empty
        expect(space.invitations).to be_empty
        expect(space.space_memberships).to be_empty
      end
    end
  end

  describe 'POST /spaces/' do
    context 'as an Operator using the API' do
      it 'creates the space from the given blueprint' do
        name = "System Test #{SecureRandom.hex(4)}"
        post spaces_path,
             params: { blueprint: :system_test, space: { name: name } },
             headers: authorization_headers(ENV['OPERATOR_API_KEY']),
             as: :json

        space = Space.find_by(name: name)
        expect(space.rooms).not_to be_empty
        expect(space.space_memberships).not_to be_empty
        expect(space.utility_hookups).not_to be_empty
      end
    end
  end
end
