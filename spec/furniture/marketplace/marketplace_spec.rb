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

  describe ".cart_for_shopper" do
    let(:shopper) { create(:marketplace_shopper) }

    it "finds an existing cart" do
      cart = create(:marketplace_cart, marketplace:, shopper:)
      expect(marketplace.cart_for_shopper(shopper:)).to eq(cart)
    end

    it "makes a new cart if there wasn't already one, defaults to :pre_checkout" do
      expect do
        expect(marketplace.cart_for_shopper(shopper:).status).to eq("pre_checkout")
      end.to change(marketplace.carts, :count).by(1)
    end

    context "when the marketplace has exactly one delivery area" do
      let!(:delivery_area) { create(:marketplace_delivery_area, marketplace:) }

      it "sets it on the cart as the default one" do
        expect(marketplace.delivery_areas.size).to eq(1)
        cart = marketplace.cart_for_shopper(shopper:)
        expect(cart.delivery_area).to eq(delivery_area)
      end
    end

    context "when the marketplace has multiple delivery areas" do
      before do
        create_list(:marketplace_delivery_area, 2, marketplace:)
      end

      it "does not set a default delivery area on the cart" do
        expect(marketplace.delivery_areas.size).to be > 1
        cart = marketplace.cart_for_shopper(shopper:)
        expect(cart.delivery_area).to be_nil
      end

      context "when only one of them is unarchived" do
        before { marketplace.delivery_areas.first.archive }

        it "sets the default delivery area to the single unarchived one" do
          cart = marketplace.cart_for_shopper(shopper:)
          expect(cart.delivery_area).to eq(marketplace.delivery_areas.unarchived.first)
        end
      end
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

  describe "#square_order_notifications_enabled?" do
    subject(:square_order_notifications_enabled?) { marketplace.square_order_notifications_enabled? }

    context "when no square settings have been set" do
      let(:marketplace) { create(:marketplace) }

      it { is_expected.to be_falsey }
    end

    context "when only one square setting has been set" do
      let(:marketplace) { create(:marketplace, square_location_id: "anything") }

      it { is_expected.to be_falsey }
    end

    context "when all square settings have been set" do
      let(:marketplace) { create(:marketplace, :with_square) }

      it { is_expected.to be_truthy }
    end
  end
end
