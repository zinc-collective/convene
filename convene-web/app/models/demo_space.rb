class DemoSpace
  # Creates the demo space, but only on environments which are
  # configured to include the demo space.
  def self.prepare
    return unless Feature.enabled?(:demo)

    Factory.new(Client).find_or_create_space!
  end

  # Assembles the DemoSpace using the provided Client and Space
  # classes.
  class Factory
    attr_accessor :client_repository

    # These are the Rooms we expect the DemoSpace to have by default.
    # Our customer team leverages them for their demonstrations of Convene's
    # feature set.
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
      },
    ].freeze

    # @param [ActiveRecord::Relation<Client>] client_repository Where to ensure there
    #  is a Zinc Client with the Convene Demo space
    def initialize(client_repository)
      self.client_repository = client_repository
    end

    # Creates the Convene Demo Space and Zinc Client if necessary
    def find_or_create_space!
      space = client.spaces.find_or_create_by!(name: 'Convene Demo')
      space.update!(jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
                        branded_domain: 'convene-demo.zinc.coop',
                        access_level: :unlocked)
      add_demo_rooms(space)
      space
    end

    private def add_demo_rooms(space)
      DEMO_ROOMS.each do |room_properties|
        room = space.rooms.find_or_initialize_by(name: room_properties[:name])
        room.update!(room_properties.except(:name))
      end
      space
    end

    private def client
      @_client ||= client_repository.find_or_create_by!(name: 'Zinc')
    end
  end
end
