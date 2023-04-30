# frozen_string_literal: true

class Marketplace
  class Cart < Record
    self.table_name = "marketplace_orders"
    location(parent: :marketplace)

    default_scope { where(status: :pre_checkout) }

    belongs_to :marketplace, inverse_of: :carts
    delegate :space, :room, to: :marketplace

    belongs_to :shopper, inverse_of: :carts

    belongs_to :delivery_area, inverse_of: :carts, optional: true

    has_many :cart_products, dependent: :destroy, inverse_of: :cart
    has_many :products, through: :cart_products, inverse_of: :carts

    # this feels like it is starting to want to be it's own model...
    has_encrypted :delivery_address
    has_encrypted :contact_phone_number
    has_encrypted :contact_email
    def contact_email
      super.presence || shopper&.email
    end

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid"
    }

    def product_total
      cart_products.sum(0, &:price_total)
    end

    def delivery
      @delivery ||= becomes(Delivery)
    end
    delegate :fee, :window, to: :delivery, prefix: true

    def tax_total
      cart_products.sum(0, &:tax_amount)
    end

    def price_total
      product_total + delivery_fee + tax_total
    end

    def ready_for_checkout?
      delivery.details_filled_in? && cart_products.present? && cart_products.all?(&:valid?)
    end
  end
end
