require "rails_helper"

RSpec.describe Marketplace::CheckoutPolicy, type: :policy do
  subject { described_class }

  let(:membership) { create(:membership, space: marketplace.room.space) }
  let(:member) { membership.member }
  let(:non_member) { create(:person) }
  let(:guest) { Guest.new }

  let(:marketplace) { create(:marketplace) }

  let(:member_checkout) { build(:marketplace_checkout, :with_cart, :with_shopper, marketplace: marketplace, person: member) }
  let(:guest_checkout) { build(:marketplace_checkout, :with_cart, :with_shopper, marketplace: marketplace) }
  let(:non_member_checkout) { build(:marketplace_checkout, :with_cart, :with_shopper, marketplace: marketplace, person: non_member) }

  permissions :new? do
    it { is_expected.to permit(member, member_checkout) }
    it { is_expected.not_to permit(non_member, member_checkout) }
    it { is_expected.not_to permit(guest, member_checkout) }
    it { is_expected.to permit(non_member, non_member_checkout) }
    it { is_expected.not_to permit(member, non_member_checkout) }
    it { is_expected.to permit(guest, guest_checkout) }
    it { is_expected.not_to permit(member, guest_checkout) }
  end

  permissions :show? do
    it { is_expected.to permit(member, member_checkout) }
    it { is_expected.not_to permit(non_member, member_checkout) }
    it { is_expected.not_to permit(guest, member_checkout) }
    it { is_expected.to permit(non_member, non_member_checkout) }
    it { is_expected.not_to permit(member, non_member_checkout) }
    it { is_expected.to permit(guest, guest_checkout) }
    it { is_expected.not_to permit(member, guest_checkout) }
  end
end
