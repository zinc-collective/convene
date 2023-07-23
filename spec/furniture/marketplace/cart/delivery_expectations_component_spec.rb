require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveryExpectationsComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(cart: cart, current_person: operator) }

  context "when the cart does not have a `delivery_area`" do
    let(:cart) { build(:marketplace_cart, marketplace: marketplace) }

    specify { expect(component.render?).to be_falsey } # rubocop:disable RSpec/PredicateMatcher
  end

  context "when the cart has a delivey area" do
    let(:cart) { build(:marketplace_cart, delivery_area: delivery_area, marketplace: marketplace) }

    context "when the `delivery_area` has an `order_by` without a `delivery_window`" do
      let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace, order_by: "8AM") }

      it { is_expected.to have_content("Order by 8AM") }
    end

    context "when the `delivery_area` has a `delivery_window` without an `order_by`" do
      let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace, delivery_window: "at Noon") }

      it { is_expected.to have_content("Orders are delivered at Noon", normalize_ws: true) }
    end

    context "when the `delivery_area` has `delivery_window` and an `order_by`" do
      let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace, delivery_window: "at Noon", order_by: "8AM") }

      it { is_expected.to have_content("Orders placed by 8AM are delivered at Noon", normalize_ws: true) }
    end

    context "when the `delivery_area` has neither an `order_by` nor a `delivery_window`" do
      let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace) }

      it {
        expect(output).to have_content("Delivers at your chosen time")
      }
    end
  end
end
