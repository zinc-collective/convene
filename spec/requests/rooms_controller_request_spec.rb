# frozen_string_literal: true

require "swagger_helper"

RSpec.describe RoomsController do # rubocop:disable RSpec/DescribeClass
  let(:space) { create(:space) }
  let(:membership) { create(:membership, space: space) }
  let!(:person) { membership.member }

  path "/spaces/{space_slug}/rooms/{room_slug}" do
    parameter name: :space_slug, in: :path, type: :string
    parameter name: :room_slug, in: :path, type: :string
    let(:api_key) { ENV["OPERATOR_API_KEY"] }
    let(:Authorization) { encode_authorization_token(api_key) } # rubocop:disable RSpec/VariableName
    include ApiHelpers::Path

    let(:space_slug) { space.slug }
    let(:room_slug) { room.slug }

    get "Returns the Room Resource" do
      tags "Room"
      security [api_key: []]
      produces "application/json"
      consumes "application/json"

      let(:room) { create(:room, :with_furniture, space: space) }

      response "200", "Room retrieved" do
        run_test! do |response|
          data = response_data(response)
          furniture_data = room.gizmos
            .map(&Furniture::Serializer.method(:new))
            .map(&:to_json)
          expect(data[:room]).to eq(id: room.id, name: room.name,
            slug: room.slug,
            furnitures: furniture_data)
        end
      end
    end

    put "Modifies the Room" do
      tags "Room"
      security [api_key: []]
      produces "application/json"
      consumes "application/json"

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          room: {
            type: :object,
            properties: {
              name: {type: :string, example: "Fancy Room"},
              slug: {type: :string, example: "fancy-room"},
              gizmos_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {}
                }
              }
            }
          }
        },
        required: ["room"]
      }

      let(:body) { {room: attributes} }

      response "200", "Room updated with furniture" do
        let(:room) { create(:room, space: space) }
        let(:attributes) do
          {name: "A new name", gizmos_attributes: [attributes_for(:furniture)]}
        end

        run_test! do
          data = response_data(response)
          expect(data[:room][:name]).to eq("A new name")
          expect(data[:room][:furnitures]).to be_present
        end
      end
    end
  end

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
    let(:room_params) { attributes_for(:room, :with_description, :with_slug, :with_media, space: space) }

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
        expect(created_room.media).to be_present
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
