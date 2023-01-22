class Marketplace
  class Order < Record
    self.table_name = "marketplace_carts"
    self.location_parent = :marketplace

    belongs_to :marketplace, inverse_of: :orders
    delegate :space, :room, to: :marketplace

    belongs_to :shopper, inverse_of: :orders

    has_many :ordered_products, inverse_of: :order, foreign_key: :cart_id
    has_many :products, through: :ordered_products, inverse_of: :orders

    enum status: {
      paid: "paid"
    }

    def price_total
      ordered_products.sum(0) do |ordered_product|
        ordered_product.product.price * ordered_product.quantity
      end
    end
  end
end
