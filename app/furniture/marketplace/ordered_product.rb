class Marketplace
  class OrderedProduct < Record
    self.table_name = "marketplace_cart_products"

    self.location_parent = :order

    belongs_to :order, inverse_of: :ordered_products, foreign_key: :cart_id

    belongs_to :product, inverse_of: :ordered_products
    delegate :name, :description, :price, :price_cents, to: :product
  end
end
