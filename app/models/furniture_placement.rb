# {Furniture} is placed in a {Room} so that it may be used by the folks who are
# in the {Room}.
#
# {Furniture} is configured using the {#settings} attribute, which is structured
# as JSON, so that {Furniture} can be tweaked and configured as appropriate for
# it's particular use case.
class FurniturePlacement < ApplicationRecord
  include RankedModel
  ranks :slot, with_same: [:room_id]

  belongs_to :room
  delegate :space, to: :room

  attribute :furniture_kind, :string

  attribute :settings, :json, default: -> { {} }

  # The order in which {Furniture} is rendered in a Room. Lower is higher.
  attribute :slot, :integer

  delegate :attributes=, to: :furniture, prefix: true

  def furniture
    @furniture ||= Furniture.from_placement(self)
  end

  def title
    furniture.model_name.human.titleize
  end

  def utilities
    space.utility_hookups
  end

  def form_template
    "furniture_placements/noop"
  end

  def configurable?
    furniture.form_template != "furniture_placements/noop"
  end
end
