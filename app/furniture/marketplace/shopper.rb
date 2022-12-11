# frozen_string_literal: true

class Marketplace
  class Shopper < ApplicationRecord
    self.table_name = 'marketplace_shoppers'

    belongs_to :person, optional: true
    has_many :carts, inverse_of: :shopper
    has_many :checkouts, inverse_of: :shopper
  end
end
