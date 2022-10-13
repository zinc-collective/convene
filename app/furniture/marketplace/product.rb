# frozen_string_literal: true

class Marketplace
  class Product < ApplicationRecord
    self.table_name = 'marketplace_products'
    belongs_to :space

    has_many :orders

    attribute :name, :string
    validates :name, presence: true

    attribute :description, :string

    monetize :price_cents
  end
end
