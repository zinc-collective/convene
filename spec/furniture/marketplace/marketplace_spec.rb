require "rails_helper"

RSpec.describe Marketplace::Marketplace, type: :model do
  it { is_expected.to have_many(:products).inverse_of(:marketplace).dependent(:destroy) }
  it { is_expected.to have_many(:orders).inverse_of(:marketplace) }
  it { is_expected.to have_many(:carts).inverse_of(:marketplace).dependent(:destroy) }

  describe "#destroy" do
    subject(:destroy) { -> { marketplace.destroy } }

    let(:marketplace) { create(:marketplace, :with_orders) }
    let(:orders) { marketplace.orders }

    context "when there are `Order`s" do
      it { is_expected.not_to raise_error }
      it { is_expected.not_to change(orders, :count) }
    end
  end
end
