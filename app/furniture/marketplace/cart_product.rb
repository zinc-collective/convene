# frozen_string_literal: true

class Marketplace
  class CartProduct < ApplicationRecord
    self.table_name = "marketplace_cart_products"

    belongs_to :cart, inverse_of: :cart_products
    belongs_to :product, inverse_of: :cart_products
    validates_uniqueness_of :product, scope: :cart_id

    attribute :quantity, :integer, default: 0

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end
