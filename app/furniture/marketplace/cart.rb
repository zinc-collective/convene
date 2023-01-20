# frozen_string_literal: true

class Marketplace
  class Cart < ApplicationRecord
    self.table_name = "marketplace_carts"
    include WithinLocation
    self.location_parent = :marketplace

    belongs_to :marketplace, inverse_of: :carts
    belongs_to :shopper, inverse_of: :carts
    delegate :space, :room, to: :marketplace
    has_many :cart_products, dependent: :destroy, inverse_of: :cart
    has_many :products, through: :cart_products, inverse_of: :carts
    has_one :checkout, inverse_of: :cart

    enum status: {
      pre_checkout: "pre_checkout",
      checked_out: "check_out"
    }

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end

    def price_total
      cart_products.sum do |cart_product|
        cart_product.product.price * cart_product.quantity
      end
    end
  end
end
