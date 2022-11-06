require "rails_helper"

RSpec.describe UtilityHookupPolicy do
  subject { described_class }

  let(:space) { create(:space, :with_members) }
  let(:utility_hookup) { create(:utility_hookup, space: space) }
  let(:member) { space.members.first }
  let(:non_member) { create(:person) }

  permissions :show? do
    it { is_expected.to permit(nil, utility_hookup) }
    it { is_expected.to permit(member, utility_hookup) }
    it { is_expected.to permit(non_member, utility_hookup) }
  end

  permissions :new?, :create?, :edit?, :update? do
    it { is_expected.to permit(member, utility_hookup) }
    it { is_expected.not_to permit(non_member, utility_hookup) }
    it { is_expected.not_to permit(nil, utility_hookup) }
  end
end
