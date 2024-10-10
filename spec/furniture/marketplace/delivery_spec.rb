require "rails_helper"

RSpec.describe Marketplace::Delivery, type: :model do
  subject(:delivery) { build(:marketplace_delivery, marketplace: marketplace, delivery_area: delivery_area) }

  let(:marketplace) { build(:marketplace) }
  let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace) }

  it { is_expected.to belong_to(:marketplace) }
  it { is_expected.to belong_to(:shopper) }
  it { is_expected.to belong_to(:delivery_area) }

  describe "#fee" do
    subject(:fee) { delivery.fee }

    context "when `delivery_area#price_cents` is nil" do
      let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace, price_cents: nil) }

      it { is_expected.to be_zero }
    end

    context "when `delivery_area#fee_as_percentage` is set" do
      let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace, fee_as_percentage: 10) }

      context "with no products" do
        it { is_expected.to be_zero }
      end

      context "with products" do
        let(:product_a) { create(:marketplace_product, marketplace:, price_cents: 10_00) }
        let(:product_b) { create(:marketplace_product, marketplace:, price_cents: 5_00) }

        before do
          delivery.ordered_products.build(product: product_a, quantity: 1)
          delivery.ordered_products.build(product: product_b, quantity: 2)
        end

        it { is_expected.to eql(Money.new(2_00)) }
      end
    end
  end

  describe "#window" do
    subject(:window) { delivery.window }

    it { is_expected.to eql(delivery.delivery_area.delivery_window) }
  end
end
