require "rails_helper"
RSpec.describe Marketplace::MarketplacesController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:membership) { create(:membership, space: space) }
  let(:member) { membership.member }

  describe "#edit" do
    subject(:executed_response) {
      get polymorphic_path(marketplace.location(:edit))
      response
    }

    context "when a Member" do
      before { sign_in(space, member) }

      it { is_expected.to render_template(:edit) }
    end

    context "when unauthenticated" do
      it { is_expected.to be_not_found }
    end
  end
end
