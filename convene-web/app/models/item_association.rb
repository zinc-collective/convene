class ItemAssociation
  attr_accessor :type, :location

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
end