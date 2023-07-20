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

  describe Marketplace::OrderPolicy::Scope do
    subject(:results) { described_class.new(actor, Marketplace::Order).resolve }

    let!(:guest_order) { create(:marketplace_order, marketplace: marketplace, shopper: create(:marketplace_shopper)) }
    let!(:neighbor_order) { create(:marketplace_order, marketplace: marketplace, shopper: create(:marketplace_shopper, person: neighbor)) }

    context "when an operator" do
      let(:actor) { operator }

      it { is_expected.to contain_exactly(guest_order, neighbor_order) }
    end

    context "when the neighbor who placed the order" do
      let(:actor) { neighbor }

      it { is_expected.to contain_exactly(neighbor_order) }
    end

    context "when a guest" do
      let(:actor) { guest }
      let!(:old_guest_order) do
        create(:marketplace_order, marketplace: marketplace, shopper: create(:marketplace_shopper), created_at: 2.weeks.ago)
      end

      it { is_expected.to contain_exactly(guest_order) }
      it { is_expected.not_to include(old_guest_order) }
    end

    context "when a member of the space" do
      let(:actor) { member }

      it { is_expected.to contain_exactly(guest_order, neighbor_order) }
    end
  end
end
