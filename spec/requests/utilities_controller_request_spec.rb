# frozen_string_literal: true

require "rails_helper"
require "support/shared_examples/a_space_member_only_route"

RSpec.describe UtilitiesController do
  let(:space) { create(:space, :with_members) }

  let(:guest) { nil }
  let(:neighbor) { create(:person) }
  let(:space_member) { space.members.first }

  let(:actor) { space_member }

  before { sign_in(space, actor) }

  describe "#index" do
    subject(:perform_request) do
      get polymorphic_path([space, :utilities])
    end

    let(:changes) { nil }

    it_behaves_like "a space-member only route"

    it "lists the Spaces Utilities" do
      create_list(:utility, 3, space: space)
      perform_request
      expect(response).to render_template(:index)
      expect(assigns(:utilities)).to eq(space.utilities)
    end
  end

  describe "#edit" do
    subject(:perform_request) do
      get "/spaces/#{space.id}/utilities/#{utility.id}/edit"
      response
    end

    let(:utility) { create(:utility, space: space) }

    it "exposes the edit form" do
      perform_request

      expect(response).to render_template(:edit)
      expect(response).to render_template(partial: "utilities/_form")
      expect(assigns(:utility)).to eq(utility)
    end
  end

  describe "#update" do
    subject(:perform_request) do
      put "/spaces/#{space.id}/utilities/#{utility.id}",
        params: {utility: attributes_for(:stripe_utility, api_token: "new-token")}
      response
    end

    let(:utility) { create(:stripe_utility, space: space) }

    it "Updates the Utility" do
      expect { perform_request }.to(change { utility.reload.attributes })

      expect(response).to redirect_to [:edit, space]
      expect(utility.utility_slug).to eq("stripe")
      expect(utility.utility.api_token).to eq("new-token")
    end
  end

  describe "#create" do
    subject(:perform_request) do
      post "/spaces/#{space.id}/utilities", params: {utility: utility_attributes}
    end

    let(:utility_attributes) { attributes_for(:utility) }

    it "creates a Utility on the given space" do
      expect { perform_request }
        .to(change { space.utilities.count }.by(1))

      expect(response).to redirect_to [:edit, space]
      expect(space.utilities.last.utility_slug).to eql("null")
      expect(space.utilities.last.utility.configuration).to eq({})
    end
  end

  describe "#destroy" do
    subject(:perform_request) do
      delete polymorphic_path(utility.location)
      response
    end

    let(:utility) { create(:utility, space: space) }

    specify { expect { perform_request }.to change { Utility.exists?(utility.id) }.from(true).to(false) }
    it { is_expected.to redirect_to(space.location(:edit)) }
  end
end
