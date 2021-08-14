class ItemRecord < ApplicationRecord
  # @return [Space, FurniturePlacement]
  belongs_to :location, polymorphic: true

  # TODO: We may want to consider using StoreModel
  # or something
  attribute :data, :json, default: {}
end
