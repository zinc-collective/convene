# An {ItemRepository} ensures that querying or creating
# items is restricted to the location.

class ItemRepository
  attr_accessor :type, :item_records, :space

  delegate :model_name, to: :type

  delegate :size, :empty?, :present?,  to: :item_records

  def initialize(type:, item_records:, space:)
    self.type = type
    self.item_records = item_records
    self.space = space
  end

  def new(attributes = {})
    type.new({ item_record: item_records.new(type: type, space: space) }.merge(attributes))
  end

  def create(attributes = {})
    new(attributes).tap(&:save)
  end

  def where(*args)
    ItemRepository.new(type: type, item_records: item_records.where(*args), space: space)
  end

  def each
    item_records.each do |item_record|
      yield item_record.item
    end
  end

  def last
    item_records.last&.item
  end

  def first
    item_records.first&.item
  end

  def include?(item)
    item_records.include?(item.item_record)
  end
end
