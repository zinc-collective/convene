class DemoSpace
  DEMO_ROOMS = [
    {
      name: "Zee's Desk",
      publicity_level: :listed,
      furniture_placements: {
        comlink: {}
      }
    },
    {
      name: "Vivek's Desk",
      publicity_level: :listed,
      furniture_placements: {
        comlink: {}
      }
    },
    {
      name: "Water Cooler",
      publicity_level: :listed,
      furniture_placements: {
        comlink: {}
      }
    },
    {
      name: "The Ada Lovelace Room",
      publicity_level: :listed,
      furniture_placements: {
        comlink: {}
      }
    },
    {
      name: "Locked Room",
      publicity_level: :listed,
      access_level: :locked,
      access_code: :friends,
      furniture_placements: {
        comlink: {}
      }
    },
  ].freeze
  def self.prepare
    return unless Feature.enabled?(:demo)

    Blueprint.new(client: {
      name: 'Zinc',
      space: {
        name: 'Convene Demo',
        jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
        branded_domain: 'convene-demo.zinc.coop',
        access_level: :unlocked,
        rooms: DEMO_ROOMS
      },
    }).find_or_create!
  end
end
