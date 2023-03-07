require "rails_helper"

RSpec.describe Marketplace::OrderPolicy, type: :policy do
  subject { described_class }

  include Marketplace::Policy::SpecFactories

  let(:order) { create(:marketplace_order, shopper: shopper, marketplace: marketplace) }
  let(:shopper) { build(:marketplace_shopper) }

  permissions :create?, :destroy?, :edit?, :show?, :update? do
    it { is_expected.to permit(member, order) }
    it { is_expected.to permit(operator, order) }

    context "when the neighbor is the shopper" do
      let(:shopper) { create(:marketplace_shopper, person: neighbor) }

      it { is_expected.to permit(neighbor, order) }
      it { is_expected.not_to permit(guest, order) }
    end

    context "when the shopper is a guest" do
      it { is_expected.not_to permit(neighbor, order) }
      it { is_expected.to permit(guest, order) }
    end
  end

  permissions :index? do
    it { is_expected.to permit(guest, Marketplace::Order) }
    it { is_expected.to permit(neighbor, Marketplace::Order) }
    it { is_expected.to permit(member, Marketplace::Order) }
    it { is_expected.to permit(operator, Marketplace::Order) }
  end
end
