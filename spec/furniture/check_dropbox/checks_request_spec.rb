# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/rooms/:room_id/furniture/check_dropbox/checks', type: :request do
  let(:space) { FactoryBot.create(:space) }
  let(:room) { FactoryBot.create(:room, space: space) }
  let!(:plaid_hookup) { FactoryBot.create(:plaid_utility_hookup, space: space) }
  let!(:check_dropbox) { FactoryBot.create(:check_dropbox, room: room) }
  let(:neighbor) { FactoryBot.create(:person) }
  let(:space_member) { FactoryBot.create(:person, spaces: [space]) }

  describe 'POST' do
    it 'creates a check' do
      check_attributes = attributes_for(:check_dropbox_check, :sort_of_real)
      VCR.use_cassette('check_dropbox/checks/create') do
        post "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks",
             { params: { check_dropbox_check: check_attributes } }
      end

      expect(check_dropbox.checks).not_to be_empty

      check = check_dropbox.checks.last

      expect(check.payer_name).to eql(check_attributes[:payer_name])
      expect(check.payer_email).to eql(check_attributes[:payer_email])
      expect(check.amount).to eql(check_attributes[:amount])
      expect(check.memo).to eql(check_attributes[:memo])
      expect(check.plaid_access_token).to include('access-sandbox')
      expect(check.plaid_item_id).to be_present
    end
  end

  describe 'GET' do
    let!(:check) {
      VCR.use_cassette('check_dropbox/checks/create') do
        check_dropbox.checks.create(attributes_for(:check_dropbox_check, :sort_of_real))
      end
    }

    it 'is a 404 for guests' do
      get "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks"

      expect(response).to be_not_found
    end

    it 'is a 404 for neighbors' do
      sign_in(space, neighbor)

      get "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks"

      expect(response).to be_not_found
    end

    it 'is a list of the checks for residents' do
      sign_in(space, space_member)

      VCR.use_cassette('check_dropbox/checks/index') do
        get "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks"
      end

      expect(response).to be_ok
      expect(response).to(render_template(:index))
      expect(assigns(:checks)).to be_present
      expect(assigns(:checks)).to include(check)
    end
  end
end
