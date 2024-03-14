class Slot < ApplicationRecord
  belongs_to :section, class_name: "Room"
  belongs_to :slottable, polymorphic: true

  include RankedModel
  ranks :slot_order, with_same: [:section_id]
end
