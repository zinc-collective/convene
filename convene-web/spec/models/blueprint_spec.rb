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
          publicity_level: :listed
        }],
        utility_hookups: [
          {
            utility_slug: :plaid,
            name: 'Plaid',
            configuration: {}
          }
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

      Blueprint.new(EXAMPLE_CONFIG).find_or_create!

      # @todo add other examples of confirming the changes
      # were not overwritten
      space.utility_hookups.reload
      expect(space.utility_hookups.first.utility.client_id).to eql('1234')
    end
  end
end
