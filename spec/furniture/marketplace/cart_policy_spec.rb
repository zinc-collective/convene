require "rails_helper"

RSpec.describe Marketplace::CartPolicy, type: :policy do
  subject { described_class }

  let(:cart) { create(:marketplace_cart, shopper: shopper, marketplace: marketplace) }
  let(:shopper) { build(:marketplace_shopper) }

  permissions :create?, :destroy?, :edit?, :show?, :update? do
    it { is_expected.to permit(member, cart) }
    it { is_expected.to permit(operator, cart) }

    context "when the neighbor is the shopper" do
      let(:shopper) { create(:marketplace_shopper, person: neighbor) }

      it { is_expected.to permit(neighbor, cart) }
      it { is_expected.not_to permit(guest, cart) }
    end

    context "when the shopper is a guest" do
      it { is_expected.not_to permit(neighbor, cart) }
      it { is_expected.to permit(guest, cart) }
    end
  end

  permissions :index? do
    it { is_expected.to permit(guest, Marketplace::Cart) }
    it { is_expected.to permit(neighbor, Marketplace::Cart) }
    it { is_expected.to permit(member, Marketplace::Cart) }
    it { is_expected.to permit(operator, Marketplace::Cart) }
  end
end
