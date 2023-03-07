# frozen_string_literal: true

require "rails_helper"

RSpec.describe Membership do
  subject(:membership) { build(:membership) }

  describe "#member" do
    it { is_expected.to belong_to(:member) }
    it { is_expected.to validate_uniqueness_of(:member).scoped_to(:space_id) }
  end

  describe "#space" do
    it { is_expected.to belong_to(:space) }
  end

  describe "#revoke" do
    it "sets the status to revoked" do
      expect { membership.revoked! }.to change(membership, :status).from("active").to("revoked")
    end
  end

  describe "#sent_invitations" do
    it { is_expected.to have_many(:sent_invitations).conditions(space: subject.space).source(:invitations).inverse_of(:invitor) }

    it "includes only invitations to the memberships space" do
      membership.save!
      invitation_to_this_space = create(:invitation, invitor: membership.member, space: membership.space)
      invitation_to_other_space = create(:invitation, invitor: membership.member)

      membership.member.reload
      expect(membership.member.invitations).to contain_exactly(invitation_to_other_space, invitation_to_this_space)

      expect(membership.sent_invitations).to include(invitation_to_this_space)
      expect(membership.sent_invitations).not_to include(invitation_to_other_space)
    end
  end
end
