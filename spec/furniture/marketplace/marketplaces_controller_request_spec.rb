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

  describe "#update" do
    before { sign_in(space, member) }

    it "updates the attributes" do
      marketplace_attributes = attributes_for(:marketplace, notify_emails: "notify@example.com")
      put polymorphic_path(marketplace.location), params: {marketplace: marketplace_attributes}
      marketplace.reload

      expect(marketplace.notify_emails).to eq(marketplace_attributes[:notify_emails])
    end
  end

  describe "#show" do
    it "does not show guests the edit button" do
      get polymorphic_path(marketplace.location)

      expect(response.body).not_to include(I18n.t("marketplace.marketplace.edit"))
      expect(response).to be_ok
    end
  end
end
