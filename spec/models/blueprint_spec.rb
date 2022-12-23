# frozen_string_literal: true

require "rails_helper"

RSpec.describe Blueprint do
  EXAMPLE_CONFIG = {
    client: {
      name: "Client A",
      space: {
        name: "Client A's Space",
        members: [{email: "client-a@example.com"}],
        rooms: [{
          name: "Room A",
          access_level: :unlocked,
          publicity_level: :listed,
          furniture_placements: {
            markdown_text_block: {content: "Obi Swan Kenobi"}
          }
        }],
        utility_hookups: []
      }
    }
  }.freeze
  describe "#find_or_create" do
    it "respects the Space's current settings" do
      Blueprint.new(EXAMPLE_CONFIG).find_or_create!

      space = Space.find_by(name: "Client A's Space")

      # @todo add other examples of changing data after the
      # blueprint has been applied
      space.rooms.first.furniture_placements.first.update(furniture_attributes: {content: "Hey there!"})

      Blueprint.new(EXAMPLE_CONFIG).find_or_create!

      # @todo add other examples of confirming the changes
      # were not overwritten
      expect(space.rooms.first.furniture_placements.first.furniture.content).to eql("Hey there!")
    end

    it "Updates a given space" do
      space = create(:space)

      Blueprint.new(EXAMPLE_CONFIG.merge(space: space)).find_or_create!

      expect(space.rooms.count).to be(1)
    end
  end
end
