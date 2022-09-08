# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipPolicy do
  subject(:policy) { described_class }
  let(:space) { create(:space) }
  let(:space_owner) do
    create(:person, name: 'Space Owner').tap do |space_owner|
      space.memberships.create!(member: space_owner)
    end
  end
  let(:invitation) { create(:invitation, space: space, email: invitee_email, status: invitation_status) }
  let(:invitee) { create(:person, name: invitee_name).tap { invitation } }
  let(:invitee_name) { "Invitee #{SecureRandom.hex(4)}" }
  let(:invitee_email) { "#{invitee_name.gsub(' ', '-')}@example.com".downcase }
  let(:invitation_status) { :pending }

  permissions :create? do
    let(:membership) { build(:membership, member: invitee, space: space) }

    it { is_expected.to permit(Operator.new, membership) }
    it { is_expected.to permit(invitee, membership) }
    it { is_expected.not_to permit(space_owner, membership) }
    context 'when the invitation has expired' do
      let(:invitation_status) { :expired }
      it { is_expected.not_to permit(invitee, membership) }
    end

    context 'when the invitation is rejected' do
      let(:invitation_status) { :rejected }
      it { is_expected.not_to permit(invitee, membership) }
    end

    context 'when the invitation is accepted' do
      let(:invitation_status) { :accepted }
      it { is_expected.not_to permit(invitee, membership) }
    end

    context 'when the invitation is pending' do
      let(:invitation_status) { :pending }
      it { is_expected.to permit(invitee, membership) }
    end

    context 'when the space membership is not for the invitee' do
      let(:membership) { build(:membership, space: space) }
      it { is_expected.not_to permit(invitee, membership) }
    end
  end

  permissions :destroy? do
    let(:member) { membership.member }
    let(:membership) { create(:membership, space: space) }
    let(:own_membership) { membership }
    let(:revoked_membership) { create(:membership, space: space, status: :revoked) }
    let(:other_membership) { create(:membership, space: space) }

    it { is_expected.to permit(Operator.new, membership) }
    it { is_expected.not_to permit(member, own_membership) }
    it { is_expected.to permit(member, other_membership) }
    it { is_expected.not_to permit(member, revoked_membership) }
    it { is_expected.not_to permit(build(:person), membership) }
  end

  describe 'Scope' do
    subject(:scope) { described_class::Scope.new(person, Membership) }

    let(:person) { create(:person) }
    let(:space) { create(:space) }
    let!(:memberships) { create_list(:membership, 3, space: space) }
    let!(:other_memberships) { create_list(:membership, 3) }

    before do
      Membership.create!(
        member: person,
        space: space
      )
    end

    it 'includes memberships for spaces the person is a member of' do
      expect(scope.resolve).to match_array(space.memberships)
    end

    it 'does not include memberships from spaces the person is not a member of' do
      expect(scope.resolve).not_to include(other_memberships)
    end
  end
end
