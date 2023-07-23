require "rails_helper"
RSpec.describe Marketplace::MarketplacesController, type: :request do
  include Spec::Marketplace::CommonLets

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

  describe "#show" do
    it "does not show guests the edit button" do
      get polymorphic_path(marketplace.location)

      expect(response.body).not_to include(I18n.t("marketplace.marketplace.edit.link_to"))
      expect(response).to be_ok
    end
  end
end
