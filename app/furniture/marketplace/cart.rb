# frozen_string_literal: true

class Marketplace
  class Cart < ApplicationRecord
    self.table_name = 'marketplace_carts'

    belongs_to :marketplace, inverse_of: :carts
    delegate :space, :room, to: :marketplace
    has_many :cart_products, dependent: :destroy, inverse_of: :cart
    has_many :products, through: :cart_products, inverse_of: :carts

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
