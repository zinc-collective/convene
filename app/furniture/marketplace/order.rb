class Marketplace
  class Order < Record
    self.table_name = "marketplace_orders"
    self.location_parent = :marketplace

    belongs_to :marketplace, inverse_of: :orders
    delegate :space, :room, to: :marketplace

    belongs_to :shopper, inverse_of: :orders

    has_many :ordered_products, inverse_of: :order, foreign_key: :cart_id
    has_many :products, through: :ordered_products, inverse_of: :orders

    has_encrypted :delivery_address
    has_encrypted :contact_phone_number

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid"
    }

    def product_total
      ordered_products.sum(0) do |ordered_product|
        ordered_product.product.price * ordered_product.quantity
      end
    end

    delegate :delivery_fee, to: :marketplace

    def price_total
      product_total + delivery_fee
    end
  end
end
