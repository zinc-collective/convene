# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blueprint do
  EXAMPLE_CONFIG = {
    client: {
      name: 'Client A',
      space: {
        name: "Client A's Space",
        members: [{ email: 'client-a@example.com' }],
        rooms: [{
          name: 'Room A',
          access_level: :unlocked,
          publicity_level: :listed,
          furniture_placements: {
            markdown_text_block: { content: "Obi Swan Kenobi" }
          }
        }],
        utility_hookups: [
          FactoryBot.attributes_for(:plaid_utility_hookup)
        ]
      }
    }
  }.freeze
  describe '#find_or_create' do
    it 'respects the servers current settings' do
      Blueprint.new(EXAMPLE_CONFIG).find_or_create!

      space = Space.find_by(name: "Client A's Space")

      # @todo add other examples of changing data after the
      # blueprint has been applied
      space.utility_hookups.first.update(utility_attributes: { client_id: '1234' })
      space.rooms.update(publicity_level: :unlisted)
      space.rooms.first.furniture_placements.first.update(furniture_attributes:{ content: "Hey there!" })

      Blueprint.new(EXAMPLE_CONFIG).find_or_create!

      # @todo add other examples of confirming the changes
      # were not overwritten
      expect(space.rooms.reload.first).to be_unlisted
      expect(space.utility_hookups.first.utility.client_id).to eql('1234')
      expect(space.rooms.first.furniture_placements.first.furniture.content).to eql("Hey there!")
    end
  end
end
