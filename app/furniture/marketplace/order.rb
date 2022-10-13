# frozen_string_literal: true

class Marketplace
  class Order < ApplicationRecord
    self.table_name = 'marketplace_orders'
    has_many :ordered_products
    has_many :products, through: :ordered_products
  end
end
