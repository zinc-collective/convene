# frozen_string_literal: true

class Marketplace
  class CartProduct < ApplicationRecord
    self.table_name = "marketplace_cart_products"

    belongs_to :cart, inverse_of: :cart_products

    belongs_to :product, inverse_of: :cart_products
    delegate :name, :description, :price, :price_cents, to: :product

    validates_uniqueness_of :product, scope: :cart_id
    validate :editable_cart

    attribute :quantity, :integer, default: 0

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end

    private

    def editable_cart
      return unless cart&.checked_out?

      errors.add(:base, "Can't edit a checked-out cart!")
    end
  end
end
