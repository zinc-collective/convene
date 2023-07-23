require "rails_helper"

RSpec.describe Marketplace::Delivery, type: :model do
  include Spec::Marketplace::CommonLets

  subject(:delivery) { build(:marketplace_delivery, marketplace: marketplace, delivery_area: delivery_area) }

  let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace) }

  it { is_expected.to belong_to(:marketplace) }
  it { is_expected.to belong_to(:shopper) }
  it { is_expected.to belong_to(:delivery_area) }

  describe "#fee" do
    subject(:fee) { delivery.fee }

    context "when `price_cents` is nil" do
      let(:delivery_area) { build(:marketplace_delivery_area, marketplace: marketplace, price_cents: nil) }

      it { is_expected.to be_zero }
    end
  end

  describe "#window" do
    subject(:window) { delivery.window }

    it { is_expected.to eql(delivery.delivery_area.delivery_window) }
  end
end
