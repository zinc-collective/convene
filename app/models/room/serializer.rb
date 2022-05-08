# frozen_string_literal: true

# Serializes {Room}s for programmatic consumption
class Room::Serializer < ApplicationSerializer
  # @return [Room]
  alias room resource

  def to_json(*_args)
    super.merge(
      room: {
        id: room.id,
        slug: room.slug,
        name: room.name,
        furniture_placements: room.furniture_placements.map(&(FurniturePlacement::Serializer.method(:new))).map(&:to_json)
      }
    )
  end
end
