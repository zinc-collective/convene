# frozen_string_literal: true

# Encapsulates where a particular piece of {Furniture} lives in a {Room} and
# what it looks like.
module Placeable
  # @return {FurniturePlacement}
  attr_accessor :placement

  delegate :id, :utilities, :persisted?, :save!, to: :placement

  def self.included(placeable)
    placeable.include ActiveModel::Model
    placeable.include ActiveModel::Attributes
    placeable.include ActiveModel::AttributeAssignment
  end

  def settings
    placement.settings
  end

  def in_room_template
    "#{self.class.name.demodulize.underscore}/in_room"
  end

  def form_template
    "#{self.class.name.demodulize.underscore}/form"
  end
end