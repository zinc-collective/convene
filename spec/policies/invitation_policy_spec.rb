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

  describe "Scope" do
    subject(:scope) { described_class::Scope.new(person, Invitation) }

    let(:membership) { create(:membership) }
    let(:person) { membership.member }
    let(:space) { membership.space }
    let!(:space_invitation) { create(:invitation, space: space) }
    let!(:other_invitation) { create(:invitation) }

    it "includes invitations for spaces the person is a member of" do
      expect(scope.resolve).to include(space_invitation)
    end

    it "does not include memberships from spaces the person is not a member of" do
      expect(scope.resolve).not_to include(other_invitation)
    end

    context "when the person is an Operator" do
      let(:person) { create(:person, :operator) }

      it "includes all invitations" do
        expect(scope.resolve).to match_array(Invitation.all)
      end
    end
  end
end
