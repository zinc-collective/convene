require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveryExpectationsComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:operator) { create(:person, operator: true) }

  let(:component) { described_class.new(cart: cart, current_person: operator) }
  let(:marketplace) { build(:marketplace) }

  context "when the cart does not have a `delivery_area`" do
    let(:cart) { build(:marketplace_cart, marketplace: marketplace) }

    context "when the `marketplace` has an `order_by` without a `delivery_window`" do
      let(:marketplace) { build(:marketplace, order_by: "by 8AM") }

      it { is_expected.to have_content("Order by 8AM") }
    end

    context "when the `marketplace` has a `delivery_window` without an `order_by`" do
      let(:marketplace) { build(:marketplace, delivery_window: "at Noon") }

      it { is_expected.to have_content("Orders are delivered at Noon", normalize_ws: true) }
    end

    context "when the `marketplace` has `delivery_window` and an `order_by`" do
      let(:marketplace) { build(:marketplace, delivery_window: "at Noon", order_by: "by 8AM") }

      it { is_expected.to have_content("Orders placed by 8AM are delivered at Noon", normalize_ws: true) }
    end

    context "when the `marketplace` has neither an `order_by` nor a `delivery_window`" do
      let(:marketplace) { build(:marketplace) }

      it {
        expect(output).to have_content("Delivers at your chosen time")
      }
    end
  end
end
