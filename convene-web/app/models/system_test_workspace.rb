class SystemTestWorkspace
  # Creates the system test workspace, but only on environments which are
  # configured to include the system test workspace.
  def self.prepare
    return unless Feature.enabled?(:system_test)

    Factory.new(Client).find_or_create_workspace!
  end

  class Factory
    attr_accessor :client_repository

    # Expand this to include more room types for different test cases
    DEMO_ROOMS = [
      {
        name: 'Listed Room 1',
        publicity_level: :listed,
        access_level: :unlocked,
        access_code: nil,
        furniture_placements: {
          tables: { names: %w[engineering design ops] }
        }
      },
      {
        name: 'Listed Room 2',
        publicity_level: :listed,
        access_level: :unlocked,
        access_code: nil
      },
      {
        name: 'Listed Locked Room 1',
        publicity_level: :listed,
        access_level: :locked,
        access_code: :secret
      },
      {
        name: 'Unlisted Room 1',
        publicity_level: :unlisted,
        access_level: :unlocked,
        access_code: nil
      },
      {
        name: 'Unlisted Room 2',
        publicity_level: :unlisted,
        access_level: :unlocked,
        access_code: nil
      }
    ].freeze

    # @param [ActiveRecord::Relation<Client>] client_repository Where to ensure there
    #  is a Zinc Client with the Convene Demo workspace
    def initialize(client_repository)
      self.client_repository = client_repository
    end

    def find_or_create_workspace!
      workspace = client.workspaces.find_or_create_by!(name: 'System Test Branded Domain')
      workspace.update!(jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
                        branded_domain: 'system-test.zinc.local',
                        access_level: :unlocked)
      add_demo_rooms(workspace)

      workspace = client.workspaces.find_or_create_by!(name: 'System Test')
      workspace.update!(jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
                        branded_domain: nil,
                        access_level: :unlocked)
      add_demo_rooms(workspace)
    end

    private def add_demo_rooms(workspace)
      DEMO_ROOMS.each do |room_properties|
        room = workspace.rooms.find_or_initialize_by(name: room_properties[:name])
        room.update!(room_properties.except(:name, :furniture_placements))

        furniture_placements = room_properties.fetch(:furniture_placements, {})
        furniture_placements.each.with_index do |(furniture, settings), slot|
          furniture_placement = room.furniture_placements
                                    .find_or_initialize_by(name: furniture)
          furniture_placement.update!(settings: settings, slot: slot)
        end
      end
      workspace
    end

    private def client
      @_client ||= client_repository.find_or_create_by!(name: 'Zinc')
    end
  end
end
