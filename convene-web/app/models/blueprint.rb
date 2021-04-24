# frozen_string_literal: true

# Assembles Spaces idempotently
class Blueprint
  attr_accessor :attributes

  def self.prepare_clients!
    CLIENTS.each do |client_attributes|
      Blueprint.new(client_attributes).find_or_create!
    end
  end

  def initialize(attributes)
    @attributes = attributes
  end

  def find_or_create!
<<<<<<< HEAD
    space.update!(space_attributes.except(:name, :rooms, :members, :entrance))

    set_rooms
=======
    space.update!(space_attributes.except(:name, :rooms, :members, :entrance, :utility_hookups))

    set_rooms
    set_utility_hookups
>>>>>>> Add request spec for creating a utility hookup
    set_members
    set_space_hookups
    set_entrance
    space
  end

  private

  def set_rooms
    space_attributes.fetch(:rooms, []).each do |room_attributes|
      room = space.rooms.find_or_initialize_by(name: room_attributes[:name])
      room.update!(room_attributes.except(:name, :furniture_placements))
      add_furniture(room, room_attributes)
    end
  end

<<<<<<< HEAD
  def add_furniture(room, room_attributes)
    furniture_placements = room_attributes.fetch(:furniture_placements, {})
    furniture_placements.each.with_index do |(furniture, settings), slot|
      furniture_placement = room.furniture_placements
                                .find_or_initialize_by(slot: slot)
      furniture_placement
        .update!(settings: furniture_placement.settings.merge(settings),
                 furniture_kind: furniture)
    end
  end

  def set_space_hookups
    space_attributes.fetch(:space_hookups, []).each do |space_hookup_attributes|
      space_hookup = space.space_hookups
                          .find_or_initialize_by(name: space_hookup_attributes[:name])
=======
  private def set_utility_hookups
    space_attributes.fetch(:utility_hookups, []).each do |utility_hookup_attributes|
      utility_hookup = space.utility_hookups
                          .find_or_initialize_by(name: utility_hookup_attributes[:name])
>>>>>>> Add request spec for creating a utility hookup

      utility_hookup.update!(utility_hookup_attributes.except(:name))
    end
  end

  def set_entrance
    space.update(entrance: space.rooms.find_by!(slug: space_attributes[:entrance])) if space_attributes[:entrance]
  end

  def set_members
    space_attributes.fetch(:members, []).each do |member_attributes|
      person = if member_attributes.is_a?(Person)
                 member_attributes
               else
                 Person.find_or_create_by!(email: member_attributes[:email])
                       .tap { |record| record.update!(member_attributes) }
               end

      space.space_memberships.find_or_create_by(member: person)
    end
  end

  def space
    @space ||= client.spaces.find_or_create_by!(name: space_attributes[:name])
  end

  def client
    @client ||= Client.find_or_create_by!(name: client_attributes[:name])
  end

  def client_attributes
    attributes[:client]
  end

  def space_attributes
    client_attributes[:space]
  end

<<<<<<< HEAD
  # @todo migrate this to a private configuration file!
  CLIENTS = [{
    client: {
      name: 'Zinc',
      space: {
        members: [{ email: 'zee@zinc.coop' }, { email: 'cheryl@zinc.coop' }],
        name: 'Zinc', branded_domain: 'meet.zinc.coop',
        access_level: :unlocked,
        entrance: 'lobby',
        space_hookups: [
          { hookup_slug: :plaid, name: 'Plaid', configuration: {} },
          {
            hookup_slug: :jitsi, name: 'Jitsi', configuration:
            { meet_domain: 'convene-videobridge-zinc.zinc.coop' }
          }
        ],
        rooms: [{
          name: 'Lobby',
=======
  # @todo migrate this to a configuration file!
  def self.prepare_clients!
    Blueprint.new(
      client: {
        name: 'Zinc',
        space: {
          utility_hookups: [
            { utility_slug: :plaid, name: 'Plaid', configuration: {} },
            {
              utility_slug: :jitsi, name: 'Jitsi', configuration:
              { meet_domain: 'convene-videobridge-zinc.zinc.coop' }
            }
          ],
          name: 'Zinc', branded_domain: 'meet.zinc.local',
>>>>>>> Add request spec for creating a utility hookup
          access_level: :unlocked,
          publicity_level: :unlisted,
          furniture_placements: {
            markdown_text_block: {}
          }
        }, {
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
  }, {
    client: {
      name: 'Zinc',
      space: {
        name: 'Convene',
        entrance: 'landing-page',
        members: [{ email: 'zee@zinc.coop' }],
        rooms: [{
          name: 'Landing Page',
          access_level: :unlocked,
          publicity_level: :unlisted,
          furniture_placements: {
            markdown_text_block: {}
          }
        }]
      }
    }
  }].freeze
end
