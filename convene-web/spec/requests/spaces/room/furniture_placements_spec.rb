require 'rails_helper'

RSpec.describe '/spaces/:space_slug/room/:room_slug/furniture_placements', type: :request do
  let(:placement) { create(:furniture_placement) }
  let(:space) { placement.room.space}
  let(:placement_path) { "/spaces/#{space.slug}/rooms/#{placement.room.slug}/furniture_placements/#{placement.id}" }

  describe 'PATCH /spaces/:space_slug/room/:room_slug/furniture_placements/:id' do
    context 'when the person is a guest' do
      it 'does not allow updating placements' do

        patch placement_path, params: { furniture_placement: { furniture_attributes: { content: 'updated content' }} }
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'when the person is a space member' do
      let(:space_membership) { create(:space_membership, space: space) }
      let!(:person) { space_membership.member }

      before do
        sign_in(person)
      end

      it 'allows updating a placement' do
        patch placement_path, params: { furniture_placement: { furniture_attributes: { content: 'updated content' }} }
        expect(response).to have_http_status(302)
        expect(placement.reload.settings['content']).to eq('updated content')
      end
    end
  end
end
