class ItemAssociation
  attr_accessor :type, :item_records

  delegate :size, to: :item_records

  def initialize(type:, item_records:)
    self.type = type
    self.item_records = item_records
  end

  def new(attributes = {})
    type.new({ item_record: item_records.new(type: type) }.merge(attributes))
  end

  def create(attributes = {})
    new(attributes).tap(&:save)
  end

  def where(*args)
    ItemAssociation.new(type: type,
      item_records: item_records.where(*args))
  end

  def each(&block)
    item_records.each do |item_record|
      yield item_record.item
    end
  end
end
