require "rails_helper"

RSpec.describe Marketplace::Marketplace, type: :model do
  it { is_expected.to have_many(:products).inverse_of(:marketplace).dependent(:destroy) }
  it { is_expected.to have_many(:orders).inverse_of(:marketplace) }
  it { is_expected.to have_many(:carts).inverse_of(:marketplace).dependent(:destroy) }

  describe "#destroy" do
    let(:marketplace) { create(:marketplace, :with_orders) }
    let(:orders) { marketplace.orders }

    context "when there are `Order`s" do
      specify { expect { marketplace.destroy }.not_to raise_error }
      specify { expect { marketplace.destroy }.not_to change(orders, :count) }
    end
  end

  describe "#delivery_window" do
    subject(:marketplace) { described_class.new }

    it "defaults to nil" do
      expect(marketplace.delivery_window).to be_nil
    end

    it "is a Time type, not just a string" do
      marketplace.delivery_window = 2.days.from_now
      expect(marketplace.delivery_window).to be_a(Time)
    end
  end
end
