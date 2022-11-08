# frozen_string_literal: true

# Serializes {Space}s for programmatic consumption
class Space::Serializer < ApplicationSerializer
  # @return [Space]
  alias_method :space, :resource

  def to_json(*_args)
    super.merge(
      space: {
        id: space.id,
        slug: space.slug,
        name: space.name
      }
    )
  end
end
