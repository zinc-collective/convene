require "rails_helper"

RSpec.describe Room, type: :model do
  describe ".listed" do
    it "does not include rooms whose publicity level is unlisted" do
      client = Client.create(name: "test")
      workspace = client.workspaces.create(name: "workspace")
      listed_room = workspace.rooms.create(publicity_level: :listed)
      unlisted_room = workspace.rooms.create(publicity_level: :unlisted)

      aggregate_failures do
        expect(Room.listed).not_to include(unlisted_room)
        expect(Room.listed).to include(listed_room)
      end

    end
  end

  let(:workspace) { Workspace.new }
  describe "#publicity_level" do
    it { is_expected.to validate_presence_of(:publicity_level) }
    it { is_expected.to validate_inclusion_of(:publicity_level).in_array(['listed', 'unlisted', :listed, :unlisted]) }

    context "when set to 'listed'" do
      subject { Room.new(publicity_level: 'listed', workspace: workspace) }
      it { is_expected.not_to be_unlisted }
      it { is_expected.to be_listed }
    end
    context "when set to 'listed'" do
      subject { Room.new(publicity_level: 'unlisted', workspace: workspace) }
      it { is_expected.to be_unlisted }
      it { is_expected.not_to be_listed }
    end
  end
end