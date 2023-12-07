require "rails_helper"

RSpec.describe Marketplace::Marketplace, type: :model do
  subject(:marketplace) { create(:marketplace) }

  it { is_expected.to have_many(:products).inverse_of(:marketplace).dependent(:destroy) }
  it { is_expected.to have_many(:orders).inverse_of(:marketplace) }
  it { is_expected.to have_many(:notification_methods).inverse_of(:marketplace).dependent(:destroy) }
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

  describe ".find_or_create_cart" do
    let(:shopper) { create(:marketplace_shopper) }

    it "finds an existing cart" do
      cart = create(:marketplace_cart, marketplace:, shopper:)
      expect(marketplace.find_or_create_cart(shopper:)).to eq(cart)
    end

    it "makes a new cart if there wasn't already one, defaults to :pre_checkout" do
      expect do
        expect(marketplace.find_or_create_cart(shopper:).status).to eq("pre_checkout")
      end.to change(marketplace.carts, :count).by(1)
    end

    it "sets the delivery area if one is passed" do
      delivery_area = create(:marketplace_delivery_area, marketplace:)
      cart = marketplace.find_or_create_cart(shopper:, delivery_area:)
      expect(cart.delivery_area).to eq(delivery_area)
    end
  end

  describe "#ready_for_shopping?" do
    subject(:ready_for_shopping?) { marketplace.ready_for_shopping? }

    context "when there is a stripe utility, product, delivery area, and stripe account" do
      let(:marketplace) { create(:marketplace, :with_stripe_utility, :with_products, :with_delivery_areas, :with_stripe_account) }

      it { is_expected.to be_truthy }
    end

    context "when there is a stripe account, product, and delivery area but no stripe utility" do
      let(:marketplace) { create(:marketplace, :with_products, :with_delivery_areas, :with_stripe_account) }

      it { is_expected.to be_falsey }
    end

    context "when there is a stripe utility, stripe account, and product but no delivery area" do
      let(:marketplace) { create(:marketplace, :with_stripe_utility, :with_products, :with_stripe_account) }

      it { is_expected.to be_falsey }
    end

    context "when there is a stripe utility, stripe account, and delivery area but no products" do
      let(:marketplace) { create(:marketplace, :with_stripe_utility, :with_delivery_areas, :with_stripe_account) }

      it { is_expected.to be_falsey }
    end

    context "when there is a stripe utility, delivery area, and product but no stripe account" do
      let(:marketplace) { create(:marketplace, :with_products, :with_stripe_utility, :with_delivery_areas) }

      it { is_expected.to be_falsey }
    end
  end
end
