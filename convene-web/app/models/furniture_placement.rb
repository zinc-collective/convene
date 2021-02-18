# {Furniture} is placed in a {Room} so that it may be used by the folks who are
# in the {Room}.
#
# {Furniture} is configured using the {#settings} attribute, which is structured
# as JSON, so that {Furniture} can be tweaked and configured as appropriate for
# it's particular use case.
class FurniturePlacement < ApplicationRecord
  belongs_to :room
  delegate :space, to: :room

  attribute :furniture_kind, :string

  validates :furniture_kind, uniqueness: { scope: :room_id }

  attribute :settings, :json

  def furniture_attributes=(attributes)
    furniture.attributes = attributes
  end

  # TODO: Ordering of records is likely handled by a well-maintained gem already
  # The order in which {Furniture} is rendered in a Room. Lower is higher.
  attribute :slot, :integer
  validates :slot, presence: true, uniqueness: { scope: :room_id }

  def furniture
    @furniture ||= Furniture.from_placement(self)
  end
end
