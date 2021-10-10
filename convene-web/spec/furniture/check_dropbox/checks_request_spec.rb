# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/rooms/:room_id/furniture/check_dropbox/checks', type: :request do
  let(:space) { FactoryBot.create(:space) }
  let(:room) { FactoryBot.create(:room, space: space) }
  let!(:check_dropbox) { FactoryBot.create(:check_dropbox, room: room) }
  describe 'POST' do
    it 'creates a check' do
      post "/spaces/#{space.id}/rooms/#{room.id}/furniture/check_dropbox/checks",
           { params: { check: { payer_name: 'Zee', payer_email: 'zee@example.com', amount: 100_00, memo: 'Example',
                                public_token: 'Fake' } } }

      expect check_dropbox.items.not_to be_empty
    end
  end
end
