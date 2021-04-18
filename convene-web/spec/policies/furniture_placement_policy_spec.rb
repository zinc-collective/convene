require 'rails_helper'

RSpec.describe FurniturePlacementPolicy do
  subject { described_class }

  let(:furniture_placement) { create(:furniture_placement) }
  let(:membership) { create(:space_membership, space: furniture_placement.space) }
  let(:member) { membership.member }
  let(:non_member) { create (:person) }

  permissions :show? do
    it { is_expected.to permit(nil, furniture_placement )}
    it { is_expected.to permit(member, furniture_placement )}
    it { is_expected.to permit(non_member, furniture_placement )}
  end

  permissions :update?, :edit? do
    it { is_expected.to permit(member, furniture_placement) }
    it { is_expected.not_to permit(non_member, furniture_placement) }
    it { is_expected.not_to permit(nil, furniture_placement) }
  end
end
