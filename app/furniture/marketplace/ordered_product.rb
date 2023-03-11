class Marketplace
  class OrderedProduct < Record
    self.table_name = "marketplace_cart_products"

    self.location_parent = :order

    belongs_to :order, inverse_of: :ordered_products, foreign_key: :cart_id

    belongs_to :product, inverse_of: :ordered_products
    delegate :name, :description, :price, :price_cents, :tax_rates, to: :product

    def tax_amount
      price_total * (tax_rates.sum(0, &:tax_rate) / 100)
    end

    def price_total
      product.price * quantity
    end
  end
end
