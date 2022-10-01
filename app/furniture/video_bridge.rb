# frozen_string_literal: true

# Provides an iFramed Jitsi Meet to a {Room}.
class VideoBridge
  include Placeable

  # @deprecated
  def in_room_template
    "#{self.class.furniture_kind}/in_room"
  end
end
