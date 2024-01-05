require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveryAreaComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(cart: cart) }

  let(:cart) { create(:marketplace_cart, marketplace: marketplace) }

  context "when a delivery area is present" do
    context "with a single delivery area" do
      let(:marketplace) { create(:marketplace, :with_delivery_areas) }

      it { is_expected.to have_content "Orders outside of this location will be subject to cancellation." }
    end

    context "with multiple delivery areas" do
      let(:marketplace) {
        create(:marketplace, :with_delivery_areas, delivery_area_quantity: 2)
      }

      it { is_expected.to have_content "Where are you Ordering from?" }
      it { is_expected.to have_content "Delivery prices and times vary based upon your location" }
      it { is_expected.to have_css("option", count: 2) }
    end
  end

  context "when a delivery area is not present" do
    let(:marketplace) { create(:marketplace) }

    it { is_expected.to have_content("Where are you Ordering from?") }
    it { is_expected.to have_content "Delivery prices and times vary based upon your location" }
    it { is_expected.to have_no_css("option") }
  end
end
