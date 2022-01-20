# frozen_string_literal: true

# {Furniture}, {Space}s, and {Neighborhood}s can all have arbitrary {Item}s
# placed within them. Generally, the {Item} class is sub-classed by particular
# kinds of Items, which provide more specific representations of domain objects.
#
# {Item} data is stored as jsonb in an {ItemRecord}, which allows new kinds of
# {Item}s to be invented without requiring database migrations.
class Item
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations

  # @return [ItemRecord]
  attr_accessor :item_record

  delegate :data, :data=, to: :item_record
  delegate :utilities, to: :item_record

  def save
    valid? ? save : false
  end
  delegate :save, to: :item_record
  delegate :persisted?, to: :item_record
  delegate :space, to: :item_record
end
