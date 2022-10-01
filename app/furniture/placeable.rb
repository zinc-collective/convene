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
  end

  module ClassMethods
    def find_by(room:)
      room.furniture_placements.find_by(furniture_kind: furniture_kind).furniture
    end

    def furniture_kind
      name.demodulize.underscore
    end
  end

  def settings
    placement.settings
  end

  def form_template
    "#{self.class.furniture_kind}/form"
  end
end
