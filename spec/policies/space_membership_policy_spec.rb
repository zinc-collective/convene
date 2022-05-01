# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpaceMembershipPolicy do
  subject(:policy) { described_class }
  let(:space) { create(:space) }
  let(:space_owner) do
    create(:person, name: 'Space Owner').tap do |space_owner|
      space.space_memberships.create!(member: space_owner)
    end
  end
  let(:invitation) { create(:invitation, space: space, email: invitee_email, status: invitation_status) }
  let(:invitee) { create(:person, name: invitee_name).tap { invitation } }
  let(:invitee_name) { "Invitee #{SecureRandom.hex(4)}" }
  let(:invitee_email) { "#{invitee_name.gsub(' ', '-')}@example.com".downcase }
  let(:invitation_status) { :sent }

  permissions :create? do
    let(:space_membership) { build(:space_membership, member: invitee, space: space) }

    it { is_expected.to permit(Operator.new, space_membership) }
    it { is_expected.to permit(invitee, space_membership) }
    it { is_expected.not_to permit(space_owner, space_membership) }
    context 'when the invitation has expired' do
      let(:invitation_status) { :expired }
      it { is_expected.not_to permit(invitee, space_membership) }
    end

    context 'when the invitation is rejected' do
      let(:invitation_status) { :rejected }
      it { is_expected.not_to permit(invitee, space_membership) }
    end

    context 'when the invitation is accepted' do
      let(:invitation_status) { :accepted }
      it { is_expected.not_to permit(invitee, space_membership) }
    end

    context 'when the invitation is pending' do
      let(:invitation_status) { :pending }
      it { is_expected.to permit(invitee, space_membership) }
    end

    context 'when the space membership is not for the invitee' do
      let(:space_membership) { build(:space_membership, space: space) }
      it { is_expected.not_to permit(invitee, space_membership) }
    end
  end
end
