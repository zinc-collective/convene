class Marketplace
  class Product < ApplicationRecord
    self.table_name = 'marketplace_products'
    belongs_to :space
  end
end
