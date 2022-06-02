# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/rooms/:room_id/furniture/spotlight/images', type: :request do
  let(:spotlight) { create(:spotlight) }
  let(:room) { spotlight.room }
  let(:space) { room.space }
  let(:space_member) { create(:person, spaces: [space]) }

  let(:params) { { spotlight_image: attributes_for(:spotlight_image) } }

  %i[post patch put].each do |method|
    describe "#{method}" do
      if %i[patch put].include?(method)
        let(:image) { create(:spotlight_image, location: spotlight.placement) }
      end

      subject do
        url = "/spaces/#{space.id}/rooms/#{room.id}/furniture/spotlight/images"
        url += "/#{image.id}" if %i[patch put].include?(method)
        public_send(method, url, params: params)
      end

      context "when the user is not logged in" do
        it "they aren't allowed to set the image" do
          subject

          expect(response).to be_not_found
          expect(spotlight.image.file).not_to be_attached
        end
      end

      context "when the user is logged in as a space member" do
        before do
          sign_in(space, space_member)
        end

        it "uploads the image and sets it" do
          subject

          expect(response).to redirect_to([space, room])
          expect(spotlight.image.file).to be_attached
        end
      end
    end
  end
end
