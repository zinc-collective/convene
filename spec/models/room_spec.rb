require "rails_helper"

RSpec.describe Room, type: :model do
  let(:space) { Space.new }

  describe ".slug" do
    it "creates unique slugs by space scope" do
      client = Client.create(name: "test")
      space_1 = client.spaces.create(name: "space1")
      space_2 = client.spaces.create(name: "space2")
      space_1_room = space_1.rooms.create(name: "room1", publicity_level: :listed)
      space_2_room = space_2.rooms.create(name: "room1", publicity_level: :listed)

      expect(space_1_room.slug).to eq "room1"
      expect(space_2_room.slug).to eq "room1"
    end
  end

  describe ".listed" do
    it "does not include rooms whose publicity level is unlisted" do
      client = Client.create(name: "test")
      space = client.spaces.create(name: "space")
      listed_room = space.rooms.create(publicity_level: :listed, name: "Listed Room")
      unlisted_room = space.rooms.create(publicity_level: :unlisted, name: "Unlisted Room")

      aggregate_failures do
        expect(Room.listed).not_to include(unlisted_room)
        expect(Room.listed).to include(listed_room)
      end
    end
  end

  describe "#publicity_level" do
    it { is_expected.to validate_presence_of(:publicity_level) }
    it { is_expected.to validate_inclusion_of(:publicity_level).in_array(["listed", "unlisted", :listed, :unlisted]) }

    context "when set to 'listed'" do
      subject { Room.new(publicity_level: "listed", space: space) }

      it { is_expected.not_to be_unlisted }
      it { is_expected.to be_listed }
    end

    context "when set to 'listed'" do
      subject { Room.new(publicity_level: "unlisted", space: space) }

      it { is_expected.to be_unlisted }
      it { is_expected.not_to be_listed }
    end
  end

  describe "#enterable?" do
    subject(:room) { Room.new(access_code: room_access_code, access_level: access_level) }

    let(:room_access_code) { nil }

    context "unlocked room" do
      let(:access_level) { "unlocked" }

      it { is_expected.to be_enterable(nil) }
      it { is_expected.to be_enterable("secret") }
    end

    context "locked room" do
      let(:access_level) { "locked" }
      let(:room_access_code) { "secret" }

      it { is_expected.not_to be_enterable(nil) }
      it { is_expected.to be_enterable("secret") }
    end
  end

  describe "#access_code" do
    context "when the Room is Locked" do
      subject(:room) { Room.new(access_level: "locked") }

      it { is_expected.to validate_presence_of(:access_code) }
    end

    context "when the Room is Unlocked" do
      subject(:room) { Room.new(access_level: "unlocked") }

      it { is_expected.not_to validate_presence_of(:access_code) }
    end
  end
end
