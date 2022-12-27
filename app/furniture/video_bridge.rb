# frozen_string_literal: true

# Provides an iFramed Jitsi Meet to a {Room}.
class VideoBridge < FurniturePlacement
  def self.from_placement(placement)
    placement.becomes(self)
  end
end
