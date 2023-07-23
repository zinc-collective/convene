require "rails_helper"

RSpec.describe Marketplace::CheckoutPolicy, type: :policy do
  subject { described_class }

  let(:checkout) { build(:marketplace_checkout, :with_cart, marketplace: marketplace, person: shopper_person) }
  let(:shopper_person) { nil }

  permissions :new?, :create?, :destroy?, :edit?, :show?, :update? do
    it { is_expected.to permit(member, checkout) }
    it { is_expected.to permit(operator, checkout) }

    context "when the neighbor is the shopper" do
      let(:shopper_person) { neighbor }

      it { is_expected.to permit(neighbor, checkout) }
      it { is_expected.not_to permit(guest, checkout) }
    end

    context "when the shopper is a guest" do
      let(:shopper_person) { guest }

      it { is_expected.not_to permit(neighbor, checkout) }
      it { is_expected.to permit(guest, checkout) }
    end
  end
end
