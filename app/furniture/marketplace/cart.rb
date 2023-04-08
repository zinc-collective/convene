# frozen_string_literal: true

class Marketplace
  class Cart < Record
    self.table_name = "marketplace_orders"
    location(parent: :marketplace)

    default_scope { where(status: :pre_checkout) }

    belongs_to :marketplace, inverse_of: :carts
    delegate :space, :room, to: :marketplace

    belongs_to :shopper, inverse_of: :carts

    has_many :cart_products, dependent: :destroy, inverse_of: :cart
    has_many :products, through: :cart_products, inverse_of: :carts

    # this feels like it is starting to want to be it's own model...
    has_encrypted :delivery_address
    attribute :delivery_window, ::Marketplace::Delivery::WindowType.new
    has_encrypted :contact_phone_number
    has_encrypted :contact_email

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

    def ready_for_shopping?
      (delivery_address.present? && contact_phone_number.present? && delivery_window.present?)
    end

    def ready_for_checkout?
      ready_for_shopping? && cart_products.present? && cart_products.all?(&:valid?)
    end
  end
end
