class TextBlock < ApplicationRecord
  belongs_to :slot
  has_one :section, through: :slot
  has_one :space, through: :section
end
