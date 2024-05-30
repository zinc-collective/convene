require "rails_helper"

RSpec.describe FurnituresController do
  let(:placement) { create(:furniture, room: room) }
  let(:room) { create(:room) }
  let(:space) { room.space }

  describe "#create" do
    subject(:perform_request) do
      post polymorphic_path(room.location(child: :furnitures)), params: {furniture: {furniture_kind: :markdown_text_block}}
    end

    let(:membership) { create(:membership, space: space) }
    let!(:person) { membership.member }

    before { sign_in(space, person) }

    specify { expect { perform_request }.to change { room.gizmos.count }.by(1) }

    it "creates a furniture placement of the kind of furniture provided within the room" do
      perform_request
      placement = room.gizmos.last
      expect(placement.furniture).to be_a(MarkdownTextBlock)
      expect(response).to redirect_to([space, room])
    end
  end

  describe "#update" do
    let(:placement_path) { polymorphic_path(placement.location) }

    context "when the person is a guest" do
      it "does not allow updating placements" do
        patch placement_path, params: {furniture: {gizmo_attributes: {content: "updated content"}}}
        expect(response).not_to have_http_status(:success)
      end
    end

    context "when the person is a space member" do
      let(:membership) { create(:membership, space: space) }
      let!(:person) { membership.member }

      before { sign_in(space, person) }

      it "allows updating a placement" do
        patch placement_path, params: {furniture: {gizmo_attributes: {content: "updated content"}}}
        expect(response).to have_http_status(:found)
        expect(placement.reload.settings["content"]).to eq("updated content")
      end
    end
  end

  describe "#destroy" do
    let(:placement_path) { polymorphic_path(placement.location) }

    context "when the person is a guest" do
      it "does not allow destroying placements" do
        delete placement_path
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
