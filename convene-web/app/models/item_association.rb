class ItemAssociation
  attr_accessor :type, :location

  delegate :item_records, to: :location
  delegate :size, to: :item_records

  def initialize(type:, location:)
    self.type = type
    self.location = location
  end

  def new(attributes = {})
    type.new({ item_record: location.item_records.new(type: type) }.merge(attributes))
  end

  def create(attributes = {})
    new(attributes).tap(&:save)
  end

  def each(&block)
    item_records.each do |item_record|
      yield item_record.item
    end
  end
end
