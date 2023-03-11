require "rails_helper"

RSpec.describe UtilityPolicy do
  subject { described_class }

  let(:space) { create(:space, :with_members) }
  let(:utility) { create(:utility, space: space) }
  let(:member) { space.members.first }
  let(:operator) { create(:person, operator: true) }
  let(:non_member) { create(:person) }

  permissions :show? do
    it { is_expected.to permit(nil, utility) }
    it { is_expected.to permit(member, utility) }
    it { is_expected.to permit(operator, utility) }
    it { is_expected.to permit(non_member, utility) }
  end

  permissions :new?, :create?, :edit?, :update? do
    it { is_expected.to permit(member, utility) }
    it { is_expected.to permit(operator, utility) }
    it { is_expected.not_to permit(non_member, utility) }
    it { is_expected.not_to permit(nil, utility) }
  end
end
