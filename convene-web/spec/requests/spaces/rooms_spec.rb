require 'rails_helper'

RSpec.describe '/spaces/:space_slug/room/', type: :request do
  let(:space) { create(:space) }
  let(:space_path) { "/spaces/#{space.slug}" }

  describe 'GET /spaces/:space_slug/room/new' do
    let(:path) { "#{space_path}/rooms/new" }

    context 'when the person is a guest' do
      it 'does not allow access to the new room form' do
        get path
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'when the person is a space member' do
      let(:space_membership) { create(:space_membership, space: space) }
      let!(:person) { space_membership.member }

      before { sign_in(space, person) }

      it 'allows access to the new room form' do
        get path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /spaces/:space_slug/room' do
    let(:path) { "#{space_path}/rooms" }
    let(:room_params) { attributes_for(:room, :with_slug, space: space) }
    subject(:do_request) { post path, params: { room: room_params } }

    context 'when the person is a guest' do
      it 'does not allow creating a new room' do
        do_request
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'when the person is a space member' do
      let(:space_membership) { create(:space_membership, space: space) }
      let!(:person) { space_membership.member }

      before { sign_in(space, person) }

      it 'creates a new room' do
        expect { do_request }.to change(Room, :count).by(1)
      end

      it 'redirects to the edit path for the new room' do
        do_request
        expect(response).to redirect_to(edit_space_room_path(space, room_params[:slug]))
      end
    end
  end
end
