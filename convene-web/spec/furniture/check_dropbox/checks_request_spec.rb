# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/rooms/:room_id/furniture/check_dropbox/checks', type: :request do
  let(:space) { FactoryBot.create(:space) }
  let(:room) { FactoryBot.create(:room, space: space) }
  let!(:plaid_hookup) { FactoryBot.create(:utility_hookup, :plaid, space: space) }
  let!(:check_dropbox) { FactoryBot.create(:check_dropbox, room: room) }
  let(:neighbor) { FactoryBot.create(:person) }
  let(:space_member) { FactoryBot.create(:person, spaces: [space]) }

  let(:fake_plaid) { instance_double(Utilities::Plaid) }
  before do
    allow(Utilities::Plaid).to receive(:new).and_return(fake_plaid)
    allow(fake_plaid).to receive(:exchange_public_token) do |attrs|
      double(access_token: "Access Token from #{attrs[:public_token]}",
             item_id: "Item Id from #{attrs[:public_token]}")
    end
    allow(fake_plaid).to receive(:account_number_for).and_return("Account Number")
    allow(fake_plaid).to receive(:routing_number_for).and_return("Routing Number")
  end
  describe 'POST' do
    it 'creates a check' do
      post "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks",
           { params: { check: { payer_name: 'Zee', payer_email: 'zee@example.com', amount: 100_00, memo: 'Example',
                                public_token: 'Fake' } } }

      expect(check_dropbox.checks).not_to be_empty
    end
  end

  describe 'GET' do
    let!(:check) { check_dropbox.checks.create(FactoryBot.attributes_for(:check_dropbox_check)) }
    it 'is a 404 for guests' do
      get "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks"
      expect(response).to be_not_found
    end

    it 'is a 404 for neighbors' do
      sign_in(space, neighbor)
      get "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks"
    end

    it 'is a list of the checks for residents' do
      sign_in(space, space_member)
      get "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks"
      expect(response).to be_ok
      expect(response).to(render_template(:index))
      expect(assigns(:checks)).to be_present
      expect(assigns(:checks)).to include(check)
    end
  end
end
