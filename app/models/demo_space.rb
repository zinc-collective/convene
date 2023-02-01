class DemoSpace
  DEMO_ROOMS = [
    {
      name: "Zee's Desk",
      publicity_level: :listed,
    },
    {
      name: "Vivek's Desk",
      publicity_level: :listed,
    },
    {
      name: "Water Cooler",
      publicity_level: :listed,
    },
    {
      name: "The Ada Lovelace Room",
      publicity_level: :listed,
    },
    {
      name: "Locked Room",
      publicity_level: :listed,
      access_level: :locked,
      access_code: :friends,
    }
  ].freeze

  # @return [Space]
  def self.prepare
    return unless Feature.enabled?(:demo)

    Blueprint.new(client: {
      name: "Zinc",
      space: {
        name: "Convene Demo",
        utility_hookups: [],
        branded_domain: "convene-demo.zinc.coop",
        members: [{email: "zee@zinc.coop"},
          {email: "vivek@zinc.coop"}],
        rooms: DEMO_ROOMS
      }
    }).find_or_create!
  end
end
