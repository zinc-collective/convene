# frozen_string_literal: true

class Marketplace
  class Product < ApplicationRecord
    self.table_name = 'marketplace_products'
    attribute :name, :string
    attribute :description, :string
    monetize :price_cents
    belongs_to :space
  end
end
