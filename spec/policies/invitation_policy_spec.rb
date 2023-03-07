require "rails_helper"

RSpec.describe InvitationPolicy do
  subject { described_class }

  let(:invitation) { create(:invitation) }
  let(:membership) { create(:membership, space: invitation.space) }
  let(:member) { membership.member }
  let(:non_member) { create(:person) }
  let(:operator) { create(:person, operator: true) }

  permissions :show? do
    it { is_expected.to permit(Guest.new, invitation) }
    it { is_expected.to permit(nil, invitation) }
    it { is_expected.to permit(non_member, invitation) }
    it { is_expected.to permit(member, invitation) }
    it { is_expected.to permit(operator, invitation) }
  end

  permissions :index?, :create?, :destroy?, :edit?, :new?, :update? do
    it { is_expected.to permit(member, invitation) }
    it { is_expected.to permit(operator, invitation) }

    it { is_expected.not_to permit(Guest.new, invitation) }
    it { is_expected.not_to permit(nil, invitation) }
    it { is_expected.not_to permit(non_member, invitation) }
  end
end
