require 'rails_helper'

RSpec.describe RoomPolicy do
  subject { described_class }

  let(:room) { create(:room) }
  let(:membership) { create(:space_membership, space: room.space) }
  let(:member) { membership.member }
  let(:non_member) { create(:person) }

  describe 'Internal Rooms' do
    let(:room) { create(:room, :internal) }
    permissions :show? do
      it { is_expected.not_to permit(nil, room) }
      it { is_expected.to permit(member, room) }
      it { is_expected.not_to permit(non_member, room) }
    end
  end

  describe 'Unlocked Rooms' do
    let(:room) { create(:room, :unlocked) }
    permissions :show? do
      it { is_expected.to permit(nil, room) }
      it { is_expected.to permit(member, room) }
      it { is_expected.to permit(non_member, room) }
    end
  end

  describe 'Locked Rooms' do
    let(:room) { create(:room, :locked) }
    # For now, because we haven't thunked through the access code bit just
    # yet.
    permissions :show? do
      it { is_expected.to permit(nil, room) }
      it { is_expected.to permit(member, room) }
      it { is_expected.to permit(non_member, room) }
    end
  end

  permissions :new?, :create?, :update?, :edit?, :destroy? do
    it { is_expected.not_to permit(nil, room) }
    it { is_expected.to permit(member, room) }
    it { is_expected.not_to permit(non_member, room) }
  end
end
