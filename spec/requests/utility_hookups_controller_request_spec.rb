# frozen_string_literal: true

require "rails_helper"
require "support/shared_examples/a_space_member_only_route"

RSpec.describe UtilityHookupsController do
  let(:space) { create(:space, :with_members) }
  let(:utility_hookup_attributes) do
    attributes_for(:utility_hookup, :stripe).merge(utility_attributes: { "api_token" => "fake-token" })
  end
  let(:utility_hookup) { create(:utility_hookup, space: space) }

  let(:guest) { nil }
  let(:neighbor) { create(:person) }
  let(:space_member) { space.members.first }

  let(:actor) { space_member }

  before { sign_in(space, actor) }

  describe "#index" do
    subject(:perform_request) do
      get polymorphic_path([space, :utility_hookups])
    end

    let(:changes) { nil }

    it_behaves_like "a space-member only route"

    it "lists the Spaces Utility Hookups" do
      create_list(:utility_hookup, 3, space: space)
      perform_request
      expect(response).to render_template(:index)
      expect(assigns(:utility_hookups)).to eq(space.utility_hookups)
    end
  end

  describe "GET /spaces/:space_id/utility_hookups/:id/edit" do
    subject(:perform_request) do
      get "/spaces/#{space.id}/utility_hookups/#{utility_hookup.id}/edit"
      response
    end

    let(:changes) {}

    it_behaves_like "a space-member only route"

    it "exposes the edit form" do
      perform_request

      expect(response).to render_template(:edit)
      expect(response).to render_template(partial: "utility_hookups/_form")
      expect(assigns(:utility_hookup)).to eq(utility_hookup)
    end
  end

  describe "PUT /spaces/:space_id/utility_hookups/:id" do
    subject(:perform_request) do
      put "/spaces/#{space.id}/utility_hookups/#{utility_hookup.id}",
        params: {utility_hookup: utility_hookup_attributes}
      response
    end

    let(:changes) { -> { utility_hookup.reload.attributes } }

    it_behaves_like "a space-member only route"

    it "Updates the Utility Hookup" do
      expect { perform_request }.to(change { utility_hookup.reload.attributes })

      expect(response).to redirect_to [:edit, space]
      expect(utility_hookup.utility_slug).to eq(utility_hookup_attributes[:utility_slug])
      expect(utility_hookup.utility.configuration).to eq(utility_hookup_attributes[:utility_attributes])
    end
  end

  describe "POST /spaces/:space_id/utility_hookups" do
    subject(:perform_request) do
      post "/spaces/#{space.id}/utility_hookups", params: {utility_hookup: utility_hookup_attributes}
    end

    let(:changes) { -> { space.utility_hookups.count } }

    it_behaves_like "a space-member only route"

    it "creates a Utility Hookup on the given space" do
      expect { perform_request }
        .to(change { space.utility_hookups.count }.by(1))

      expect(response).to redirect_to [:edit, space]
      expect(space.utility_hookups.last.utility_slug).to eql("stripe")
      expect(space.utility_hookups.last.utility.configuration).to eq(utility_hookup_attributes[:utility_attributes])
    end
  end
end
