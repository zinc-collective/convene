# frozen_string_literal: true

# Assembles Spaces idempotently
class Blueprint
  attr_accessor :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def find_or_create!
    space.update!(space_attributes.except(:name, :rooms, :members, :entrance, :space_hookups))

    set_rooms
    set_space_hookups
    set_members
    set_entrance
    space
  end

  private def set_rooms
    space_attributes.fetch(:rooms, []).each do |room_attributes|
      room = space.rooms.find_or_initialize_by(name: room_attributes[:name])
      room.update!(room_attributes.except(:name, :furniture_placements))
      furniture_placements = room_attributes.fetch(:furniture_placements, {})
      furniture_placements.each.with_index do |(furniture, settings), slot|
        furniture_placement = room.furniture_placements
                                  .find_or_initialize_by(slot: slot)
        furniture_placement.update!(settings: settings, furniture_kind: furniture)
      end
    end
  end

  private def set_space_hookups
    space_attributes.fetch(:space_hookups, []).each do |space_hookup_attributes|
      space_hookup = space.space_hookups
                          .find_or_initialize_by(name: space_hookup_attributes[:name])

      space_hookup.update!(space_hookup_attributes.except(:name))
    end
  end

  private def set_entrance
    space.update(entrance: space.rooms.find_by!(slug: space_attributes[:entrance])) if space_attributes[:entrance]
  end

  private def set_members
    space_attributes.fetch(:members, []).each do |person|
      space.members << person
    end
  end

  private def space
    @_space ||= client.spaces.find_or_create_by!(name: space_attributes[:name])
  end

  private def client
    @_client ||= Client.find_or_create_by!(name: client_attributes[:name])
  end

  private def client_attributes
    attributes[:client]
  end

  private def space_attributes
    client_attributes[:space]
  end

  # @todo migrate this to a configuration file!
  def self.prepare_clients!
    Blueprint.new(
      client: {
        name: 'Zinc',
        space: {
          space_hookups: [
            { hookup_slug: :plaid, name: 'Plaid', configuration: {} },
            {
              hookup_slug: :jitsi, name: 'Jitsi', configuration:
              { meet_domain: 'convene-videobridge-zinc.zinc.coop' }
            }
          ],
          name: 'Zinc', branded_domain: 'meet.zinc.local',
          access_level: :unlocked,
          rooms: [{
            name: 'Ada',
            access_level: :unlocked,
            publicity_level: :listed,
            furniture_placements: {
              videobridge_by_jitsi: {}
            }
          }, {
            name: 'Talk to Zee',
            access_level: :unlocked,
            publicity_level: :unlisted,
            furniture_placements: {
              videobridge_by_jitsi: {}
            }
          }]
        }
      }
    ).find_or_create!
  end
end
