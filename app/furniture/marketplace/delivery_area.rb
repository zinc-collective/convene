class Marketplace
  class DeliveryArea < Record
    include Discardable

    self.table_name = "marketplace_delivery_areas"
    location(parent: :marketplace)

    belongs_to :marketplace, inverse_of: :delivery_areas
    has_many :orders, -> { checked_out }, inverse_of: :delivery_area
    has_many :carts, inverse_of: :delivery_area, dependent: :nullify
    after_discard do
      carts.update_all(delivery_area_id: nil) # rubocop:disable Rails/SkipsModelValidations
    end

    has_many :deliveries, inverse_of: :delivery_area

    attribute :delivery_window
    monetize :price_cents
  end
end
