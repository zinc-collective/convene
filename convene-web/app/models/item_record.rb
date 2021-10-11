# frozen_string_literal: true

# Persists {Item} data and connects them to their appropriate location in the
# {Neighborhood}.
class ItemRecord < ApplicationRecord
  # @return [FurniturePlacement]
  belongs_to :location, polymorphic: true, inverse_of: :item_records
  delegate :utilities, to: :location
  belongs_to :space, inverse_of: :item_records

  # @todo pull this out to an {ActiveRecord::Type} that marshals and unmarshals
  # the {Item}. Maybe StoreModel would work for this?
  attribute :data, :json, default: {}

  def item
    @item ||= type.new(item_record: self)
  end

  def type
    @type ||= data['type'].constantize
  end

  def type=(type)
    @type = type
    data['type'] = type.to_s

    self.type
  end

  before_save :set_type

  def set_type
    data['type'] = item.class.to_s
  end
end
