require 'rails_helper'

RSpec.describe FurniturePlacementPolicy do
  subject { described_class }

  let(:furniture_placement) { create(:furniture_placement) }
  let(:membership) { create(:space_membership, space: furniture_placement.space) }
  let(:member) { membership.member }
  let(:non_member) { create (:person) }

  permissions :update?, :edit? do
    it "grants access if user is space member" do
      expect(subject).to permit(member, furniture_placement)
    end

    it "denies access if user is not a space member" do
      expect(subject).not_to permit(non_member, furniture_placement)
    end
  end
end
