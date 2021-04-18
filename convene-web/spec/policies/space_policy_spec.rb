require 'rails_helper'

RSpec.describe SpacePolicy do
  subject { described_class }

  let(:membership) { create(:space_membership) }
  let(:space) { membership.space }
  let(:member) { membership.member }
  let(:non_member) { create (:person) }

  permissions :update? do
    it "grants access if user is space member" do
      expect(subject).to permit(member, space)
    end

    it "denies access if user is not a space member" do
      expect(subject).not_to permit(non_member, space)
    end
  end
end
