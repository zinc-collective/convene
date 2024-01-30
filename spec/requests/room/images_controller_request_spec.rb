require "rails_helper"

RSpec.describe Room::ImagesController do
  let(:space) { create(:space) }
  let(:membership) { create(:membership, space: space) }
  let!(:person) { membership.member }
  let(:room) { create(:room, space: space) }

  describe "#create" do
    subject(:do_request) do
      post path, params: params
      response
    end

    let(:path) { polymorphic_path(room.location(child: :images)) }
    let(:params) { {hero_image_upload: Rack::Test::UploadedFile.new("spec/fixtures/files/cc-kitten.jpg", "image/jpeg")} }

    context "when the person is signed in as a member" do
      before { sign_in(space, person) }

      context "when a hero image does not exist" do
        specify do
          do_request
          expect(room.reload.hero_image).to be_present
        end

        it { is_expected.to redirect_to(room.location(:edit)) }
      end

      # context "when a hero image does exist" do
      #   # TODO
      # end
    end
  end
end
