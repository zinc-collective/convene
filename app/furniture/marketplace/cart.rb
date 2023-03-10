# frozen_string_literal: true

class Marketplace
  class Cart < Record
    self.table_name = "marketplace_orders"
    self.location_parent = :marketplace

    default_scope { where(status: :pre_checkout) }

    belongs_to :marketplace, inverse_of: :carts
    delegate :space, :room, to: :marketplace

    belongs_to :shopper, inverse_of: :carts

    has_many :cart_products, dependent: :destroy, inverse_of: :cart
    has_many :products, through: :cart_products, inverse_of: :carts

    has_encrypted :delivery_address
    has_encrypted :contact_phone_number

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid"
    }

    def product_total
      cart_products.sum(0) do |cart_product|
        cart_product.price_total
      end
    end

    def delivery_fee
      return marketplace.delivery_fee if delivery_address.present?

      0
    end

    def tax_total
      cart_products.sum(0, &:tax_amount)
    end

    def price_total
      product_total + delivery_fee + tax_total
    end

    def ready_for_delivery?
      (delivery_address.present? && contact_phone_number.present?)
    end
  end
end
