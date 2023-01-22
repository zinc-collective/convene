# frozen_string_literal: true

class Marketplace
  class Cart < Record
    self.table_name = "marketplace_carts"
    self.location_parent = :marketplace

    default_scope { where(status: :pre_checkout) }

    belongs_to :marketplace, inverse_of: :carts
    delegate :space, :room, to: :marketplace

    belongs_to :shopper, inverse_of: :carts

    has_many :cart_products, dependent: :destroy, inverse_of: :cart
    has_many :products, through: :cart_products, inverse_of: :carts

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid"
    }

    def price_total
      cart_products.sum(0) do |cart_product|
        cart_product.product.price * cart_product.quantity
      end
    end
  end
end
