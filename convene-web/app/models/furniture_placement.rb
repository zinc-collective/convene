# {Furniture} is placed in a {Room} so that it may be used by the folks who are
# in the {Room}.
#
# {Furniture} is configured using the {#settings} attribute, which is structured
# as JSON, so that {Furniture} can be tweaked and configured as appropriate for
# it's particular use case.
class FurniturePlacement < ApplicationRecord
  belongs_to :room
  delegate :space, to: :room

  has_many :item_records, as: :location

  attribute :furniture_kind, :string

  attribute :settings, :json, default: {}

  def furniture_attributes=(attributes)
    furniture.attributes = attributes
  end

  # TODO: Ordering of records is likely handled by a well-maintained gem already
  # The order in which {Furniture} is rendered in a Room. Lower is higher.
  attribute :slot, :integer
  validates :slot, presence: true, uniqueness: { scope: :room_id }

  before_validation :infer_slot
  def furniture
    @furniture ||= Furniture.from_placement(self)
  end

  def utilities
    space.utility_hookups
  end

  def infer_slot
    return if slot.present?

    self.slot = room&.furniture_placements&.count || 0
  end
end
