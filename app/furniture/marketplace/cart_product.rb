# frozen_string_literal: true

class Marketplace
  class CartProduct < Record
    self.table_name = "marketplace_cart_products"

    belongs_to :cart, inverse_of: :cart_products
    delegate :shopper, to: :cart

    belongs_to :product, inverse_of: :cart_products
    delegate :name, :description, :marketplace, :price, :price_cents, :tax_rates, to: :product

    validates_uniqueness_of :product, scope: :cart_id
    validate :editable_cart

    attribute :quantity, :integer, default: 0

    def tax_amount
      price_total * (tax_rates.sum(0) do |tax_rate|
        tax_rate.tax_rate
      end / 100)
    end

    def price_total
      product.price * quantity
    end

    private

    def editable_cart
      return if cart&.pre_checkout?

      errors.add(:base, "Can't edit a checked-out cart!")
    end
  end
end
