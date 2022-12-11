class Marketplace
  class Checkout < ApplicationRecord
    self.table_name = 'marketplace_checkouts'

    belongs_to :cart, inverse_of: :checkout
    belongs_to :shopper, inverse_of: :checkouts
  end
end
