require "rails_helper"

RSpec.describe Marketplace::MarketplaceComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(marketplace: marketplace, current_person: current_person) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping) }
  let(:current_person) { Guest.new }

  delegate :dom_id, to: :component

  context "when the current person can edit the marketplace" do
    let(:current_person) { create(:person, operator: true) }

    it { is_expected.to have_no_css("##{dom_id(marketplace, :onboarding)}") }
    it { is_expected.to have_link(I18n.t("marketplace.marketplace.edit.link_to"), href: polymorphic_path(marketplace.location(:edit))) }

    context "when the marketplace is not fully configured" do
      let(:marketplace) { create(:marketplace) }

      it { is_expected.to have_css("##{dom_id(marketplace, :onboarding)}") }
    end
  end

  context "when the current person cannot edit the marketplace" do
    it { is_expected.to have_no_link(I18n.t("marketplace.marketplace.edit.link_to"), href: polymorphic_path(marketplace.location(:edit))) }

    context "when the marketplace is not fully configured" do
      let(:marketplace) { create(:marketplace) }

      describe "#render?" do
        subject(:render?) { component.render? }

        it { is_expected.not_to be_truthy }
      end
    end
  end

  describe "#cart" do
    let(:current_person) { create(:person) }

    context "when there is not a Cart for the Shopper in the Marketplace" do
      it "creates a Cart for the Shopper" do
        expect { component.cart }.to change { marketplace.carts.count }.by(1)
        expect(component.cart).to be_persisted
        expect(component.cart.delivery_area).to eql(marketplace.delivery_areas.first)
      end

      context "when the Marketplace has multiple Delivery Areas" do
        it "creates a Cart for the Shopper without a Delivery Area" do
          create(:marketplace_delivery_area, marketplace:)
          expect { component.cart }.to change { marketplace.carts.count }.by(1)
          expect(component.cart).to be_persisted
          expect(component.cart.delivery_area).to be_nil
        end
      end
    end

    context "when there is a Cart for the Shopper in the Marketplace" do
      before do
        marketplace.carts.create(shopper: Marketplace::Shopper.create(person: current_person))
      end

      it "doesn't create another cart" do
        expect { component.cart }.not_to change { marketplace.carts.count }
      end

      context "when the Marketplace has multiple DeliveryAreas" do
        it "doesn't create another cart" do
          create(:marketplace_delivery_area, marketplace:)
          expect { component.cart }.not_to change { marketplace.carts.count }
        end
      end
    end
  end
end
