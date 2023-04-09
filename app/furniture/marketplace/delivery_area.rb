class Marketplace
  class DeliveryArea < Record
    self.table_name = "marketplace_delivery_areas"
    location(parent: :marketplace)

    belongs_to :marketplace, inverse_of: :delivery_areas
    has_many :orders, inverse_of: :delivery_area
    has_many :deliveries, inverse_of: :delivery_area

    monetize :price_cents
  end
end
