require "rails_helper"

RSpec.describe Marketplace::Marketplace, type: :model do
  it { is_expected.to have_many(:products).inverse_of(:marketplace).dependent(:destroy) }
  it { is_expected.to have_many(:orders).inverse_of(:marketplace) }
  it { is_expected.to have_many(:carts).inverse_of(:marketplace).dependent(:destroy) }
  it { is_expected.to have_many(:delivery_areas).inverse_of(:marketplace).dependent(:destroy) }
  it { is_expected.to have_many(:tax_rates).inverse_of(:marketplace) }

  describe "#destroy" do
    let(:marketplace) { create(:marketplace, :with_orders) }
    let(:orders) { marketplace.orders }

    context "when there are `Order`s" do
      specify { expect { marketplace.destroy }.not_to raise_error }
      specify { expect { marketplace.destroy }.not_to change(orders, :count) }
    end
  end

  describe ".all" do
    subject(:all) { described_class.all }

    let!(:non_marketplace_furniture) { create(:journal) }
    let!(:marketplace_furniture) { create(:marketplace) }

    it { is_expected.not_to include(non_marketplace_furniture) }
    it { is_expected.to include(marketplace_furniture) }
  end
end
