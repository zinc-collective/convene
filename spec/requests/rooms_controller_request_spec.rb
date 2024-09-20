# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoomsController do # rubocop:disable RSpec/DescribeClass
  let(:space) { create(:space) }
  let(:membership) { create(:membership, space: space) }
  let!(:person) { membership.member }

  describe "#new" do
    let(:path) { polymorphic_path(space.location(:new, child: :room)) }

    context "when the person is a guest" do
      it "does not allow access to the new room form" do
        get path
        expect(response).not_to have_http_status(:success)
      end
    end

    context "when the person is a space member" do
      before { sign_in(space, person) }

      it "allows access to the new room form" do
        get path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "#destroy" do
    let(:room) { create(:room, space: space) }
    let(:path) { space_room_path(room.space, room) }

    context "when the person is a guest" do
      it "does not remove the room" do
        delete path
        expect(room.reload).to be_present
        expect(response).not_to have_http_status(:success)
      end
    end

    context "when the person is a space member" do
      let(:membership) { create(:membership, space: space) }
      let!(:person) { membership.member }

      before { sign_in(space, person) }

      it "removes the room" do
        delete path
        expect { room.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to redirect_to([:edit, room.space])
        expect(flash[:notice]).to eql(I18n.t("rooms.destroy.success", room_name: room.name))
      end
    end
  end

  describe "#create" do
    subject(:do_request) {
      post path, params: {room: room_params}
      response
    }

    let(:path) { polymorphic_path(space.location(child: :rooms)) }
    let(:room_params) { attributes_for(:room, :with_description, :with_slug, space: space) }

    context "when the person is a guest" do
      it "does not allow creating a new room" do
        do_request
        expect(response).not_to have_http_status(:success)
      end
    end

    context "when the person is a space member" do
      let(:membership) { create(:membership, space: space) }
      let!(:person) { membership.member }

      before { sign_in(space, person) }

      it "creates the room" do
        expect { do_request }.to(change { space.rooms.count }.by(1))
        created_room = space.rooms.last
        expect(created_room.slug).to eql(room_params[:slug])
        expect(created_room.description).to eql(room_params[:description])
        expect(response).to redirect_to(polymorphic_path(space.rooms.last.location(:edit)))
      end

      context "when the space has an entrance" do
        it "still creates the room" do
          space.update(entrance: create(:room, space: space))

          expect { do_request }.to(change { space.rooms.count }.by(1))
          expect(response).to redirect_to(polymorphic_path(space.rooms.order(created_at: :desc).first.location(:edit)))
        end
      end
    end
  end
end
