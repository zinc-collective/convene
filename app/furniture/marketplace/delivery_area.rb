class Marketplace
  class DeliveryArea < Record
    self.table_name = "marketplace_delivery_areas"
    location(parent: :marketplace)

    belongs_to :marketplace, inverse_of: :delivery_areas

    monetize :price_cents
  end
end
