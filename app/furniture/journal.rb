# frozen_string_literal: true

# @see features/furniture/journal.feature.md
class Journal
  def self.from_placement(placement)
    placement.becomes(Journal)
  end
end
