# frozen_string_literal: true

class Marketplace
  class Product < Record
    self.table_name = "marketplace_products"
    location(parent: :marketplace)

    extend StripsNamespaceFromModelName

    belongs_to :marketplace, inverse_of: :products
    delegate :space, to: :marketplace

    has_many :cart_products, inverse_of: :product, dependent: :destroy
    has_many :carts, through: :cart_products, inverse_of: :products

    has_many :ordered_products, inverse_of: :product, dependent: :destroy
    has_many :orders, through: :ordered_products, inverse_of: :products

    has_many :product_tax_rates, inverse_of: :product, dependent: :destroy
    has_many :tax_rates, through: :product_tax_rates, inverse_of: :products

    attribute :name, :string
    validates :name, presence: true

    attribute :description, :string

    monetize :price_cents
  end
end
