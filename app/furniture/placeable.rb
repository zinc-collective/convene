# frozen_string_literal: true

# Encapsulates where a particular piece of {Furniture} lives in a {Room} and
# what it looks like.
module Placeable
  # @return {FurniturePlacement}
  attr_accessor :placement

  delegate :id, :room, :space, :utilities, :persisted?, :save!, to: :placement

  def self.included(placeable)
    placeable.include ActiveModel::Model
    placeable.include ActiveModel::Attributes
    placeable.include ActiveModel::AttributeAssignment
    placeable.extend ClassMethods
    placeable.include InstanceMethods
  end

  # @todo is there a better way to not clobber our instance methods when we include stuff?
  #       Perhaps what we want to do is switch `placeable` from a module to a class that
  #       Furniture inherits from?
  module InstanceMethods
    def settings
      placement.settings
    end

    # Allows us to `render furniture` and use the partial at `furniture/_furniture.html.erb`
    # @example Assuming `spotlight` is a {Spotlight} that inherits {Placeable}
    #      render spotlight # renders spotlight/_spotlight.html.erb
    # @see https://api.rubyonrails.org/classes/ActiveModel/Conversion.html#method-i-to_partial_path
    def to_partial_path
      "#{self.class.furniture_kind}/#{self.class.furniture_kind}"
    end

    def form_template
      "#{self.class.furniture_kind}/form"
    end
  end

  module ClassMethods
    def find_by(room:)
      room.furniture_placements.find_by(furniture_kind: furniture_kind).furniture
    end

    def furniture_kind
      @furniture_kind ||= name.demodulize.underscore
    end
  end
end
