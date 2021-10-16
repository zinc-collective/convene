class DemoSpace
  DEMO_ROOMS = [
    {
      name: "Zee's Desk",
      publicity_level: :listed,
      furniture_placements: {
        videobridge_by_jitsi: {}
      }
    },
    {
      name: "Vivek's Desk",
      publicity_level: :listed,
      furniture_placements: {
        videobridge_by_jitsi: {}
      }
    },
    {
      name: 'Water Cooler',
      publicity_level: :listed,
      furniture_placements: {
        videobridge_by_jitsi: {}
      }
    },
    {
      name: 'The Ada Lovelace Room',
      publicity_level: :listed,
      furniture_placements: {
        videobridge_by_jitsi: {}
      }
    },
    {
      name: 'Locked Room',
      publicity_level: :listed,
      access_level: :locked,
      access_code: :friends,
      furniture_placements: {
        videobridge_by_jitsi: {}
      }
    }
  ].freeze

  UTILITY_HOOKUPS = [
    FactoryBot.attributes_for(:utility_hookup, :plaid),
    { utility_slug: :jitsi, name: 'Jitsi', configuration:
      { meet_domain: 'convene-videobridge-zinc.zinc.coop' } }
  ].freeze

  # @return [Space]
  def self.prepare
    return unless Feature.enabled?(:demo)

    Blueprint.new(client: {
                    name: 'Zinc',
                    space: {
                      name: 'Convene Demo',
                      utility_hookups: UTILITY_HOOKUPS,
                      branded_domain: 'convene-demo.zinc.coop',
                      members: [{ email: 'zee@zinc.coop' },
                                { email: 'vivek@zinc.coop' }],
                      rooms: DEMO_ROOMS
                    }
                  }).find_or_create!
  end
end
