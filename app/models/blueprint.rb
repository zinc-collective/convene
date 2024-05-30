# frozen_string_literal: true

# Assembles Spaces idempotently
class Blueprint
  attr_accessor :attributes

  attr_writer :space

  def initialize(attributes, space: nil)
    @attributes = attributes
    self.space = space
  end

  def find_or_create!
    space.update!(space_attributes.except(:name, :rooms, :members, :entrance, :utilities))

    set_rooms
    set_utilities
    set_members
    set_entrance
    space
  end

  private

  def set_rooms
    space_attributes.fetch(:rooms, []).each do |room_attributes|
      room = space.rooms.find_or_initialize_by(name: room_attributes[:name])
      room.update!(merge_non_empty(room.attributes, room_attributes).except(:name, :furnitures))
      add_furniture(room, room_attributes)
    end
  end

  def add_furniture(room, room_attributes)
    furnitures = room_attributes.fetch(:furnitures, {})
    furnitures.each.with_index do |(furniture_kind, settings), position|
      furniture = room.gizmos
        .find_or_initialize_by(position: position)
      furniture
        .update!(settings: merge_non_empty(settings, furniture.settings),
          furniture_kind: furniture_kind)
    end
  end

  def set_utilities
    space_attributes.fetch(:utilities, []).each do |utility_attributes|
      utility = space.utilities
        .find_or_initialize_by(name: utility_attributes[:name])

      utility.update!(merge_non_empty(utility_attributes, utility.attributes))
    end
  end

  def set_entrance
    if space_attributes[:entrance]
      space.update!(entrance: space.rooms.find_by!(slug: space_attributes[:entrance]))
    end
  end

  def set_members
    space_attributes.fetch(:members, []).each do |member_attributes|
      person = if member_attributes.is_a?(Person)
        member_attributes
      else
        Person.find_or_create_by!(email: member_attributes[:email])
          .tap { |record| record.update!(member_attributes) }
      end

      space.memberships.find_or_create_by(member: person)
    end
  end

  def space
    @space ||= Space.find_or_create_by!(name: space_attributes[:name])
  end

  def space_attributes
    attributes
  end

  # Normally, merge will clobber keys with values if there is a key with a nil
  # or empty value. However, we don't want to do that here.
  # @example
  #   new = {  a: "ah", b: { c: :d } }
  #   original = { "a" => nil, "b" => {} }
  #   merge_non_empty(new, original)
  #   # => { "a" => "ah", "b": { c: :d }}
  private def merge_non_empty(left, right)
    right.compact_blank!

    left.with_indifferent_access.merge(right.with_indifferent_access)
  end

  BLUEPRINTS = {
    system_test: {
      entrance: "entrance-hall",
      utilities: [],
      members: [{email: "space-owner@example.com"},
        {email: "space-member@example.com"}],
      rooms: [
        {
          name: "Room 1",
          access_level: :public,
          furnitures: {
            markdown_text_block: {content: "# Welcome!"}
          }
        },
        {
          name: "Room 2",
          access_level: :public,
          furnitures: {}
        },
        {
          name: "Internal Room 1",
          access_level: :internal,
          furnitures: {}
        },
        {
          name: "Entrance Hall",
          furnitures: {
            markdown_text_block: {content: "# Wooo!"}
          }
        }
      ]
    }
  }.with_indifferent_access
end
