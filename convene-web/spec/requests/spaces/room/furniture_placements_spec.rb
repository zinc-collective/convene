require 'rails_helper'

RSpec.describe '/spaces/:space_slug/room/:room_slug/furniture_placements', type: :request do
  let(:placement) { create(:furniture_placement) }
  let(:space) { placement.room.space }
  let(:placement_path) { "/spaces/#{space.slug}/rooms/#{placement.room.slug}/furniture_placements/#{placement.id}" }
  let(:placement_params) do
    {
      furniture_placement:
      {
        furniture_kind: :markdown_text_block,
        furniture_attributes: { content: 'updated content' }
      }
    }
  end

  describe 'PATCH /spaces/:space_slug/room/:room_slug/furniture_placements/:id' do
    context 'when the person is a guest' do
      it 'does not allow updating placements' do
        patch placement_path, params: placement_params
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'when the person is a space member' do
      let(:space_membership) { create(:space_membership, space: space) }
      let!(:person) { space_membership.member }

      before { sign_in(space, person) }

      it 'allows updating a placement' do
        patch placement_path, params: placement_params
        expect(response).to have_http_status(302)
        expect(placement.reload.settings['content']).to eq('updated content')
      end
    end
  end
end
