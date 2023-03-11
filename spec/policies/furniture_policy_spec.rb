require "rails_helper"

RSpec.describe FurniturePolicy do
  subject { described_class }

  let(:furniture) { create(:furniture) }
  let(:membership) { create(:membership, space: furniture.space) }
  let(:member) { membership.member }
  let(:non_member) { create(:person) }

  permissions :show? do
    it { is_expected.to permit(nil, furniture) }
    it { is_expected.to permit(member, furniture) }
    it { is_expected.to permit(non_member, furniture) }
  end

  permissions :update?, :create?, :edit?, :new? do
    it { is_expected.to permit(member, furniture) }
    it { is_expected.not_to permit(non_member, furniture) }
    it { is_expected.not_to permit(nil, furniture) }
  end
end
