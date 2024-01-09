require "rails_helper"

RSpec.describe Room do
  let(:space) { Space.new }

  it { is_expected.to have_many(:gizmos).inverse_of(:room).dependent(:destroy) }
  it { is_expected.to belong_to(:space).inverse_of(:rooms) }

  it { is_expected.to have_one_attached(:image) }

  describe "#description" do
    it { is_expected.to validate_length_of(:description).is_at_most(300).allow_blank }
  end

  describe ".slug" do
    it "creates unique slugs by space scope" do
      space_1 = Space.create(name: "space1")
      space_2 = Space.create(name: "space2")
      space_1_room = space_1.rooms.create(name: "room1")
      space_2_room = space_2.rooms.create(name: "room1")

      expect(space_1_room.slug).to eq "room1"
      expect(space_2_room.slug).to eq "room1"
    end
  end
end
