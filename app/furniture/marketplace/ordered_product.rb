# frozen_string_literal: true

class Marketplace
  class OrderedProduct < ApplicationRecord
    self.table_name = 'marketplace_ordered_products'

    belongs_to :order
    belongs_to :product
  end
end
