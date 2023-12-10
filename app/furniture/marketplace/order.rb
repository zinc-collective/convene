class Marketplace
  class Order < Record
    self.table_name = "marketplace_orders"
    default_scope { where.not(status: :pre_checkout) }
    location(parent: :marketplace)

    belongs_to :marketplace, inverse_of: :orders
    delegate :space, :room, to: :marketplace

    belongs_to :delivery_area, inverse_of: :orders, optional: true

    belongs_to :shopper, inverse_of: :orders

    has_many :ordered_products, inverse_of: :order, foreign_key: :cart_id, dependent: :destroy
    has_many :products, through: :ordered_products, inverse_of: :orders
    has_many :events, inverse_of: :regarding, dependent: :destroy, as: :regarding

    has_encrypted :delivery_address
    has_encrypted :contact_phone_number
    has_encrypted :contact_email

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid"
    }

    monetize :payment_processor_fee_cents
    def vendors_share
      product_total - payment_processor_fee
    end

    def product_total
      ordered_products.sum(0, &:price_total)
    end

    def tax_total
      ordered_products.sum(0, &:tax_amount)
    end

    def delivery
      becomes(Delivery)
    end

    def delivery_fee
      delivery_area&.price
    end
    delegate :delivery_window, to: :delivery_area, allow_nil: true

    def marketplace_name
      marketplace.room.name
    end

    def price_total
      [product_total, delivery_fee, tax_total].compact.sum(0)
    end
  end
end
