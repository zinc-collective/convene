# frozen_string_literal: true

class Item
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment

  # @return [ItemRecord]
  attr_accessor :item_record

  delegate :data, to: :item_record
  delegate :utilities, to: :item_record
  delegate :save, to: :item_record
end
