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
end