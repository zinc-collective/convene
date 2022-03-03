# frozen_string_literal: true

# Persists {Item} data and connects them to their appropriate location in the
# {Neighborhood}.
#
# {Furniture}, {Space}s, and {Neighborhood}s can all have arbitrary {Item}s
# placed within them. Generally, the {Item} class is sub-classed by particular
# kinds of Items, which provide more specific representations of domain objects.
#
# {Item} data is stored as jsonb in an {ItemRecord}, which allows new kinds of
# {Item}s to be invented without requiring database migrations.
class Item < ApplicationRecord
  # @return [FurniturePlacement]
  belongs_to :location, inverse_of: :items, optional: true, class_name: 'FurniturePlacement'
  delegate :utilities, to: :location

  belongs_to :space, inverse_of: :items

  # @todo pull this out to an {ActiveRecord::Type} that marshals and unmarshals
  # the {Item}. Maybe StoreModel would work for this?
  attribute :data, :json, default: {}

  before_validation :infer_space, if: -> { space.blank? }

  private def infer_space
    return if space.present?
    return if location.blank?

    self.space = location.space
  end
end
