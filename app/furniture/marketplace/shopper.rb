# frozen_string_literal: true

class Marketplace
  class Shopper < Record
    self.table_name = "marketplace_shoppers"

    belongs_to :person, optional: true
    has_many :carts, inverse_of: :shopper
    has_many :orders, inverse_of: :shopper
  end
end
