class DemoSpace
  DEMO_ROOMS = [
    {
      name: "Zee's Desk",
      publicity_level: :listed,
      furniture_placements: {
        video_bridge: {}
      }
    },
    {
      name: "Vivek's Desk",
      publicity_level: :listed,
      furniture_placements: {
        video_bridge: {}
      }
    },
    {
      name: 'Water Cooler',
      publicity_level: :listed,
      furniture_placements: {
        video_bridge: {}
      }
    },
    {
      name: 'The Ada Lovelace Room',
      publicity_level: :listed,
      furniture_placements: {
        video_bridge: {}
      }
    },
    {
      name: 'Locked Room',
      publicity_level: :listed,
      access_level: :locked,
      access_code: :friends,
      furniture_placements: {
        video_bridge: {}
      }
    }
  ].freeze



  # @return [Space]
  def self.prepare
    return unless Feature.enabled?(:demo)

    Blueprint.new(client: {
                    name: 'Zinc',
                    space: {
                      name: 'Convene Demo',
                      utility_hookups: utility_hookups,
                      branded_domain: 'convene-demo.zinc.coop',
                      members: [{ email: 'zee@zinc.coop' },
                                { email: 'vivek@zinc.coop' }],
                      rooms: DEMO_ROOMS
                    }
                  }).find_or_create!
  end

  def self.utility_hookups
    [
      FactoryBot.attributes_for(:plaid_utility_hookup),
      { utility_slug: :jitsi, name: 'Jitsi', configuration:
        { meet_domain: 'convene-videobridge-zinc.zinc.coop' } }
    ]
  end
end
