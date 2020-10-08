require "rails_helper"

RSpec.describe Room, type: :model do
  describe ".slug" do
    it "creates unique slugs by workspace scope" do
      client = Client.create(name: "test")
      workspace_1 = client.workspaces.create(name: "workspace1")
      workspace_2 = client.workspaces.create(name: "workspace2")
      workspace_1_room = workspace_1.rooms.create(name: 'room1', publicity_level: :listed)
      workspace_2_room = workspace_2.rooms.create(name: 'room1', publicity_level: :listed)

      expect(workspace_1_room.slug).to eq 'room1'
      expect(workspace_2_room.slug).to eq 'room1'
    end
  end

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

  describe "#enterable?" do
    subject(:room) { Room.new(access_code: room_access_code, access_level: access_level) }
    let(:room_access_code) { nil }

    context "unlocked room" do
      let(:access_level) { 'unlocked' }
      it { is_expected.to be_enterable(nil) }
      it { is_expected.to be_enterable('secret') }
    end

    context "locked room" do
      let(:access_level) { 'locked' }
      let(:room_access_code) { 'secret' }
      it { is_expected.to_not be_enterable(nil) }
      it { is_expected.to be_enterable('secret') }
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