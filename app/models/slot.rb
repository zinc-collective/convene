class Slot < ApplicationRecord
  belongs_to :section, class_name: "Room", inverse_of: :slots
  self.location_parent = :section
  has_one :space, through: :section

  belongs_to :slottable, polymorphic: true, inverse_of: :slot

  include RankedModel
  ranks :slot_order, with_same: [:section_id]
end
