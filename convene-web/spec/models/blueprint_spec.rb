require "rails_helper"

RSpec.describe Blueprint, type: :model do
  describe "#find_or_create!" do
    it "created space and assoicated data" do
      client_attributes = {
        client: {
          name: 'System Test',
          space: {
            name: 'System Test',
            jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
            access_level: :unlocked,
            rooms: [
              {
                name: 'Listed Room 1',
                publicity_level: :listed,
                access_level: :unlocked,
                access_code: nil,
                furniture_placements: {
                  markdown_text_block: { content: "# Welcome!" },
                  videobridge_by_jitsi: {},
                  breakout_tables_by_jitsi: { names: %w[engineering design ops] }
                }
              }
            ]
          }
        }
      }

      described_class.new(client_attributes).find_or_create!

    end
  end
end