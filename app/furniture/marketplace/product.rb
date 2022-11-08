# frozen_string_literal: true

class Marketplace
  class Product < ApplicationRecord
    self.table_name = 'marketplace_products'

    extend StripsNamespaceFromModelName

    belongs_to :marketplace
    delegate :space, to: :marketplace

    has_many :ordered_products, inverse_of: :product
    has_many :orders, through: :ordered_products

    attribute :name, :string
    validates :name, presence: true

    attribute :description, :string

    monetize :price_cents

    def location
      marketplace.location(self)
    end
  end
end
