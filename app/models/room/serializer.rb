# frozen_string_literal: true

# Serializes {Room}s for programmatic consumption
class Room::Serializer < ApplicationSerializer
  # @return [Room]
  alias_method :room, :resource

  def to_json(*_args)
    super.merge(
      room: {
        id: room.id,
        slug: room.slug,
        name: room.name,
        furnitures: room.furnitures.map(&Furniture::Serializer.method(:new)).map(&:to_json)
      }
    )
  end
end
