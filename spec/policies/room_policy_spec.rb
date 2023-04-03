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
    subject(:results) { described_class.new(person, space.rooms).resolve }

    let(:space) { room.space }
    let!(:internal_room) { create(:room, :internal, space: space) }
    let!(:public_room) { create(:room, :public, space: space) }
    let!(:listed_room) { create(:room, :listed, space: space) }
    let!(:unlisted_room) { create(:room, :unlisted, space: space) }

    context "when person is an operator" do
      let(:person) { operator }

      it "returns all the rooms" do
        expect(results).to include(internal_room)
        expect(results).to include(public_room)
        expect(results).to include(unlisted_room)
        expect(results).to include(listed_room)
      end
    end

    context "when person is a member" do
      let(:person) { member }

      it "returns all the rooms" do
        expect(results).to include(internal_room)
        expect(results).to include(public_room)
        expect(results).to include(unlisted_room)
        expect(results).to include(listed_room)
      end
    end

    context "when person is not a member" do
      let(:person) { non_member }

      it "returns only the public rooms" do
        expect(results).to include(public_room)
        expect(results).to include(unlisted_room)
        expect(results).to include(listed_room)

        expect(results).not_to include(internal_room)
      end
    end
  end
end
