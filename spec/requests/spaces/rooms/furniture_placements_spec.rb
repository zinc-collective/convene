require "rails_helper"

RSpec.describe "/spaces/:space_slug/rooms/:room_slug/furniture_placements", type: :request do
  let(:placement) { create(:furniture_placement, room: room) }
  let(:room) { create(:room) }
  let(:space) { room.space }

  describe "POST /spaces/:space_slug/rooms/:room_slug/furniture_placements" do
    let(:membership) { create(:membership, space: space) }
    let!(:person) { membership.member }

    before { sign_in(space, person) }

    it "creates a furniture placement of the kind of furniture provided within the room" do
      expect do
        post space_room_furniture_placements_path(space, room), params: {furniture_placement: {furniture_kind: :markdown_text_block}}
      end.to change { room.furniture_placements.count }.by(1)

      placement = room.furniture_placements.last
      expect(placement.furniture).to be_a(MarkdownTextBlock)
      expect(placement.slot).to be(0)
      expect(response).to redirect_to([space, room])
    end
  end

  describe "PATCH /spaces/:space_slug/rooms/:room_slug/furniture_placements/:id" do
    let(:placement_path) { space_room_furniture_placement_path(space, room, placement) }

    context "when the person is a guest" do
      it "does not allow updating placements" do
        patch placement_path, params: {furniture_placement: {furniture_attributes: {content: "updated content"}}}
        expect(response).not_to have_http_status(:success)
      end
    end

    context "when the person is a space member" do
      let(:membership) { create(:membership, space: space) }
      let!(:person) { membership.member }

      before { sign_in(space, person) }

      it "allows updating a placement" do
        patch placement_path, params: {furniture_placement: {furniture_attributes: {content: "updated content"}}}
        expect(response).to have_http_status(:found)
        expect(placement.reload.settings["content"]).to eq("updated content")
      end
    end
  end

  describe "DELETE /spaces/:space_slug/rooms/:room_slug/furniture_placements/:id" do
    let(:placement_path) { space_room_furniture_placement_path(space, room, placement) }

    context "when the person is a guest" do
      it "does not allow destroying placements" do
        patch placement_path, params: {furniture_placement: {furniture_attributes: {content: "updated content"}}}
        expect(response).not_to have_http_status(:success)
        expect(placement.reload).to be_present
      end
    end

    context "when the person is a space member" do
      let(:membership) { create(:membership, space: space) }
      let!(:person) { membership.member }

      before { sign_in(space, person) }

      it "allows destroying a placement" do
        delete placement_path
        expect(response).to redirect_to([space, room])
        expect { placement.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
