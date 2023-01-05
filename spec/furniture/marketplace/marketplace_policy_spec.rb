require "rails_helper"

RSpec.describe Marketplace::MarketplacePolicy, type: :policy do
  subject { described_class }

  let(:marketplace) { create(:marketplace) }
  let(:membership) { create(:membership, space: marketplace.room.space ) }
  let(:member) { membership.member }
  let(:non_member) { create(:person) }
  let(:guest) { nil }

  permissions :show? do
    it { is_expected.to permit(member, marketplace) }
    it { is_expected.to permit(non_member, marketplace) }
    it { is_expected.to permit(guest, marketplace) }
  end

  permissions :update? do
    it { is_expected.to permit(member, marketplace) }
    it { is_expected.not_to permit(non_member, marketplace) }
    it { is_expected.not_to permit(guest, marketplace) }
  end
end
