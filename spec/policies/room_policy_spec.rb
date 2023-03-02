require "rails_helper"

RSpec.describe RoomPolicy do
  subject { described_class }

  let(:room) { create(:room) }
  let(:membership) { create(:membership, space: room.space) }
  let(:member) { membership.member }
  let(:non_member) { create(:person) }
  let(:operator) { create(:person, operator: true) }

  describe "Internal Rooms" do
    let(:room) { create(:room, :internal) }

    permissions :show? do
      it { is_expected.not_to permit(nil, room) }
      it { is_expected.to permit(member, room) }
      it { is_expected.to permit(operator, room) }
      it { is_expected.not_to permit(non_member, room) }
    end
  end

  describe "Unlocked Rooms" do
    let(:room) { create(:room, :unlocked) }

    permissions :show? do
      it { is_expected.to permit(nil, room) }
      it { is_expected.to permit(member, room) }
      it { is_expected.to permit(operator, room) }
      it { is_expected.to permit(non_member, room) }
    end
  end

  describe "Locked Rooms" do
    let(:room) { create(:room, :locked) }

    # For now, because we haven't thunked through the access code bit just
    # yet.
    permissions :show? do
      it { is_expected.to permit(nil, room) }
      it { is_expected.to permit(member, room) }
      it { is_expected.to permit(operator, room) }
      it { is_expected.to permit(non_member, room) }
    end
  end

  permissions :new?, :create?, :update?, :edit?, :destroy? do
    it { is_expected.not_to permit(nil, room) }
    it { is_expected.to permit(member, room) }
    it { is_expected.to permit(operator, room) }
    it { is_expected.not_to permit(non_member, room) }
  end

  describe RoomPolicy::Scope do
    it "includes all the rooms" do
      space = create(:space)
      internal_room = create(:room, :internal, space: space)
      locked_room = create(:room, :locked, space: space)
      unlocked_room = create(:room, :unlocked, space: space)
      listed_room = create(:room, :listed, space: space)
      unlisted_room = create(:room, :unlisted, space: space)

      results = RoomPolicy::Scope.new(nil, space.rooms).resolve

      expect(results).to include(internal_room)
      expect(results).to include(locked_room)
      expect(results).to include(unlocked_room)
      expect(results).to include(unlisted_room)
      expect(results).to include(listed_room)
    end
  end
end
