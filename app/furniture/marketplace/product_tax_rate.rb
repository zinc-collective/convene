class Marketplace
  class ProductTaxRate < Record
    self.table_name = :marketplace_product_tax_rates

    belongs_to :product, inverse_of: :product_tax_rates
    belongs_to :tax_rate, inverse_of: :product_tax_rates
  end
end
