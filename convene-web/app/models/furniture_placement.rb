# {Furniture} placed in a {Room} allows it to be used
class FurniturePlacement < ApplicationRecord
  belongs_to :room
  delegate :space, to: :room

  attribute :furniture_kind, :string
  def name
    furniture_kind
  end

  def name=name
    self.furniture_kind=name
  end

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
