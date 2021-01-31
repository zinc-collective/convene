# {Furniture} placed in a {Room} allows it to be used
class FurniturePlacement < ApplicationRecord
  belongs_to :room
  delegate :space, to: :room

  attribute :name, :string
  validates :name, uniqueness: { scope: :room_id }

  attribute :settings, :json

  # TODO: Ordering of records is likely handled by a well-maintained gem already
  # The order in which {Furniture} is rendered in a Room. Lower is higher.
  attribute :slot, :integer
  validates :slot, presence: true, uniqueness: { scope: :room_id }

  # TODO: Furniture probably wants to have a Registry that finds and
  # instantiates the appropriate furniture class for the placement.
  def furniture
    @furniture ||= Furniture.from_placement(self)
  end
end
