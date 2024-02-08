class Marketplace
  class ProductTag < Record
    self.table_name = :marketplace_product_tags

    belongs_to :product, inverse_of: :product_tags
    belongs_to :tag, inverse_of: :product_tags
  end
end
