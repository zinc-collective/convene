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

  describe "Public Rooms" do
    let(:room) { create(:room, :public) }

    permissions :show? do
      it { is_expected.to permit(nil, room) }
      it { is_expected.to permit(member, room) }
      it { is_expected.to permit(operator, room) }
      it { is_expected.to permit(non_member, room) }
    end
  end

  permissions :new?, :create?, :destroy?, :edit?, :update? do
    it { is_expected.not_to permit(nil, room) }
    it { is_expected.to permit(member, room) }
    it { is_expected.to permit(operator, room) }
    it { is_expected.not_to permit(non_member, room) }
  end

  describe RoomPolicy::Scope do
    it "includes all the rooms" do
      space = create(:space)
      internal_room = create(:room, :internal, space: space)
      public_rom = create(:room, :public, space: space)
      listed_room = create(:room, :listed, space: space)
      unlisted_room = create(:room, :unlisted, space: space)

      results = RoomPolicy::Scope.new(nil, space.rooms).resolve

      expect(results).to include(internal_room)
      expect(results).to include(public_rom)
      expect(results).to include(unlisted_room)
      expect(results).to include(listed_room)
    end
  end
end
