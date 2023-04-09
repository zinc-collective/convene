require "rails_helper"

RSpec.describe Marketplace::Delivery, type: :model do
  subject(:delivery) { build(:marketplace_delivery, marketplace: marketplace, delivery_area: delivery_area) }

  let(:marketplace) { build(:marketplace) }
  let(:delivery_area) { nil }

  it { is_expected.to belong_to(:marketplace) }
  it { is_expected.to belong_to(:shopper) }
  it { is_expected.to belong_to(:delivery_area) }

  describe "#delivery_window" do
    subject(:delivery_window) { delivery.delivery_window }

    it { is_expected.to be_a(Marketplace::Delivery::Window) }
  end

  describe "#fee" do
    subject(:fee) { delivery.fee }

    context "when there is not a marketplace delivery fee or a delivery area delivery fee" do
      it { is_expected.to eq(0) }
    end

    context "when the marketplace has a delivery fee and the delivery area has a delivery fee" do
      let(:marketplace) { build(:marketplace, delivery_fee_cents: 25_00) }
      let(:delivery_area) { build(:marketplace_delivery_area, price_cents: 50_00, marketplace: marketplace) }

      it { is_expected.to eq(delivery_area.price) }
    end

    context "when the marketplace has a delivery fee but the delivery area does not" do
      let(:marketplace) { build(:marketplace, delivery_fee_cents: 25_00) }
      let(:delivery_area) { build(:marketplace_delivery_area, price_cents: nil, marketplace: marketplace) }

      it { is_expected.to eq(marketplace.delivery_fee) }
    end
  end

  describe "#window" do
    subject(:window) { delivery.window }

    it { is_expected.to eql(delivery.delivery_window) }
  end
end
