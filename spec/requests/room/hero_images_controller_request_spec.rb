require "rails_helper"

RSpec.describe Room::HeroImagesController do
  let(:space) { create(:space) }
  let(:membership) { create(:membership, space: space) }
  let!(:person) { membership.member }
  let(:room) { create(:room, space: space) }
  let(:upload) { Rack::Test::UploadedFile.new("spec/fixtures/files/cc-kitten.jpg", "image/jpeg") }

  describe "#create" do
    subject(:do_request) do
      post path, params: params
      room.reload
      response
    end

    let(:path) { polymorphic_path(room.location(child: :hero_image)) }
    let(:params) { {media: {upload: upload}} }

    context "when the person is signed in as a space member" do
      before { sign_in(space, person) }

      context "when a hero image does not exist" do
        it "adds a new hero image" do
          do_request
          expect(room.reload.hero_image).to be_present
          expect(response).to redirect_to(room.location(:edit))
        end
      end

      context "when a hero image does exist" do
        let(:hero_image) { create(:media) }
        let(:room) { create(:room, hero_image: hero_image, space: space) }

        it "replaces the existing hero image with a new hero image" do
          expect { do_request }.to change(room, :hero_image_id)
          expect(Media).not_to exist(id: hero_image.id)
          expect(response).to redirect_to(room.location(:edit))
        end
      end
    end
  end
end
