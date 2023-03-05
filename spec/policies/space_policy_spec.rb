require "rails_helper"

RSpec.describe SpacePolicy do
  subject { described_class }

  let(:membership) { create(:membership) }
  let(:space) { membership.space }
  let(:member) { membership.member }
  let(:non_member) { create(:person) }
  let(:operator) { create(:person, operator: true) }

  permissions :update?, :edit? do
    it { is_expected.to permit(member, space) }
    it { is_expected.to permit(operator, space) }

    it { is_expected.not_to permit(non_member, space) }
    it { is_expected.not_to permit(nil, space) }
  end
end
