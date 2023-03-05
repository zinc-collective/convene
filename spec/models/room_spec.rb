require "rails_helper"

RSpec.describe Room do
  let(:space) { Space.new }

  describe ".slug" do
    it "creates unique slugs by space scope" do
      space_1 = Space.create(name: "space1")
      space_2 = Space.create(name: "space2")
      space_1_room = space_1.rooms.create(name: "room1", publicity_level: :listed)
      space_2_room = space_2.rooms.create(name: "room1", publicity_level: :listed)

      expect(space_1_room.slug).to eq "room1"
      expect(space_2_room.slug).to eq "room1"
    end
  end

  describe ".listed" do
    it "does not include rooms whose publicity level is unlisted" do
      space = Space.create(name: "space")
      listed_room = space.rooms.create(publicity_level: :listed, name: "Listed Room")
      unlisted_room = space.rooms.create(publicity_level: :unlisted, name: "Unlisted Room")

      aggregate_failures do
        expect(described_class.listed).not_to include(unlisted_room)
        expect(described_class.listed).to include(listed_room)
      end
    end
  end

  describe "#publicity_level" do
    it { is_expected.to validate_presence_of(:publicity_level) }
    it { is_expected.to validate_inclusion_of(:publicity_level).in_array(["listed", "unlisted", :listed, :unlisted]) }

    context "when set to 'listed'" do
      subject { described_class.new(publicity_level: "listed", space: space) }

      it { is_expected.not_to be_unlisted }
      it { is_expected.to be_listed }
    end

    context "when set to 'listed'" do
      subject { described_class.new(publicity_level: "unlisted", space: space) }

      it { is_expected.to be_unlisted }
      it { is_expected.not_to be_listed }
    end
  end
end
