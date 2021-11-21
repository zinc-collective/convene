require 'rails_helper'

RSpec.describe '/spaces/', type: :request do
  include ActiveJob::TestHelper
  describe 'DELETE /spaces/:space_slug/' do
    context 'when passing in the global operator authentication header' do
      it "deletes the space and all it's other bits" do
        SystemTestSpace.prepare

        space = Space.find_by(slug: 'system-test')
        authorization_headers = {
          'HTTP_AUTHORIZATION' =>
            ActionController::HttpAuthentication::Token.encode_credentials( ENV['OPERATOR_API_KEY'])
        }
        delete space_path(space), headers: authorization_headers, as: :json

        perform_enqueued_jobs

        expect(space.rooms).to be_empty
        expect(space.utility_hookups).to be_empty
        expect(space.item_records).to be_empty
        expect(space.invitations).to be_empty
        expect(space.space_memberships).to be_empty
      end
    end
  end
end