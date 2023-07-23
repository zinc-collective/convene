require "rails_helper"

RSpec.describe Marketplace::CartProductPolicy, type: :policy do
  subject { described_class }

  let(:cart) { create(:marketplace_cart, shopper: shopper, marketplace: marketplace) }
  let(:shopper) { build(:marketplace_shopper) }
  let(:cart_product) { create(:marketplace_cart_product, cart: cart, marketplace: marketplace) }

  permissions :create?, :destroy?, :edit?, :show?, :update? do
    it { is_expected.to permit(member, cart_product) }
    it { is_expected.to permit(operator, cart_product) }

    context "when the neighbor is the shopper" do
      let(:shopper) { create(:marketplace_shopper, person: neighbor) }

      it { is_expected.to permit(neighbor, cart_product) }
      it { is_expected.not_to permit(guest, cart_product) }
    end

    context "when the shopper is a guest" do
      it { is_expected.not_to permit(neighbor, cart_product) }
      it { is_expected.to permit(guest, cart_product) }
    end
  end

  permissions :index? do
    it { is_expected.to permit(guest, Marketplace::CartProduct) }
    it { is_expected.to permit(neighbor, Marketplace::CartProduct) }
    it { is_expected.to permit(member, Marketplace::CartProduct) }
    it { is_expected.to permit(operator, Marketplace::CartProduct) }
  end
end
