class ItemRecord < ApplicationRecord
  # @return [Space, FurniturePlacement]
  belongs_to :location, polymorphic: true
  delegate :utilities, to: :location

  # TODO: We may want to consider using StoreModel
  # or something
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
