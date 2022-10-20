# frozen_string_literal: true

class Marketplace
  class Order < ApplicationRecord
    self.table_name = 'marketplace_orders'

    belongs_to :marketplace
    delegate :space, :room, to: :marketplace 
    has_many :ordered_products
    has_many :products, through: :ordered_products
  end
end
