# frozen_string_literal: true

class Marketplace
  class Product < ApplicationRecord
    self.table_name = 'marketplace_products'

    extend StripsNamespaceFromModelName

    belongs_to :marketplace, inverse_of: :products
    delegate :space, to: :marketplace

    has_many :cart_products, inverse_of: :product, dependent: :destroy
    has_many :carts, through: :cart_products, inverse_of: :products

    attribute :name, :string
    validates :name, presence: true

    attribute :description, :string

    monetize :price_cents

    def location
      marketplace.location(self)
    end
  end
end
