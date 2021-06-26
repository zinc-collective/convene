require 'rails_helper'

RSpec.describe '/spaces/:space_slug/room/', type: :request do
  let(:space) { create(:space) }

  describe 'GET /spaces/:space_slug/rooms/new' do
    let(:path) { new_space_room_path(space) }

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

  describe 'DELETE /spaces/:space_slug/rooms/:room_slug' do
    let(:room) { create(:room, space: space) }
    let(:path) { space_room_path(room.space, room) }
    context 'when the person is a guest' do
      it 'does not remove the room' do
        delete path
        expect(room.reload).to be_present
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'when the person is a space member' do
      let(:space_membership) { create(:space_membership, space: space) }
      let!(:person) { space_membership.member }

      before { sign_in(space, person) }

      it 'removes the room' do
        delete path
        expect { room.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to redirect_to(edit_space_path(room.space))
        expect(flash[:notice]).to eql(I18n.t('rooms.destroy.success', room_name: room.name))
      end
    end
  end

  describe 'POST /spaces/:space_slug/room' do
    let(:path) { space_rooms_path(space) }
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
