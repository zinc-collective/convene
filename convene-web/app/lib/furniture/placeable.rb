module Furniture
  # Encapsulates where a particular piece of {Furniture} lives in a {Room} and
  # what it looks like.
  module Placeable
    # @return {FurniturePlacement}
    attr_accessor :placement

    delegate :settings, to: :placement

    def initialize(placement)
      self.placement = placement
    end

    def in_room_template
      "#{self.class.name.demodulize.underscore}/in_room"
    end
  end
end
