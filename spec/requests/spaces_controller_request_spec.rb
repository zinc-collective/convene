# frozen_string_literal: true

require "swagger_helper"

RSpec.describe SpacesController, type: :request do
  include ActiveJob::TestHelper

  describe "#show" do
    context "with a branded domain" do
      let(:space) { create(:space, branded_domain: "beta.example.com") }

      it "links to the domain" do
        get polymorphic_path(space)

        expect(response.body).to include "//beta.example.com/"
      end
    end
  end

  path "/spaces" do
    include ApiHelpers::Path

    post "Creates a Space" do
      tags "Spaces"
      consumes "application/json"
      produces "application/json"

      security [api_key: []]
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          space: {
            type: :object,
            properties: {
              name: {type: :string, example: "A Cool Book Club for Cool Folks"},
              blueprint: {type: :string, optional: true, example: "book_club"}
            },
            required: ["name"]
          }
        },
        required: ["space"]
      }

      let(:api_key) { ENV["OPERATOR_API_KEY"] }
      let(:Authorization) { encode_authorization_token(api_key) }
      let(:body) { {space: attributes} }
      response "201", "space created" do
        let(:attributes) { attributes_for(:space, :with_client_attributes) }
        run_test! do |_response|
          space = Space.find_by(name: attributes[:name])
          expect(space.rooms).to be_empty
          expect(space.memberships).to be_empty
          expect(space.utility_hookups).to be_empty
        end
      end

      context "with a blueprint" do
        let(:attributes) { attributes_for(:space, :with_client_attributes, blueprint: :system_test) }

        response "201", "space created from the blueprint" do
          run_test! do |_response|
            space = Space.find_by(name: attributes[:name])
            expect(space.rooms).not_to be_empty
            expect(space.memberships).not_to be_empty
            expect(space.utility_hookups).not_to be_empty
          end
        end
      end
    end
  end
  describe "#destroy" do
    context "as an Operator using the API" do
      it "deletes the space and all it's other bits" do
        SystemTestSpace.prepare

        space = Space.find_by(slug: "system-test")
        delete polymorphic_path(space),
          headers: authorization_headers,
          as: :json

        perform_enqueued_jobs

        expect(space.rooms).to be_empty
        expect(space.utility_hookups).to be_empty
        expect(space.invitations).to be_empty
        expect(space.memberships).to be_empty
      end
    end
  end

  describe "#update" do
    context "when a Space Member" do
      let(:space) { create(:space, :with_members, theme: "purple_mountains") }

      before do
        sign_in_as_member(space)
      end

      it "updates the theme" do
        put polymorphic_path(space), params: {space: {theme: "desert_dunes"}}

        expect(space.reload.theme).to eq("desert_dunes")
        expect(flash[:notice]).to include("successfully updated")
      end

      it "shows an error message with an invalid theme" do
        put polymorphic_path(space), params: {space: {theme: "bogus_theme"}}

        expect(space.reload.theme).to eq("purple_mountains")
        expect(flash[:alert]).to include("went wrong")
      end
    end
  end
end
