class Marketplace
  class TaxRate < Record
    self.table_name = "marketplace_tax_rates"
    location(parent: :marketplace)

    belongs_to :marketplace, inverse_of: :tax_rates
    has_many :product_tax_rates, inverse_of: :tax_rate
    has_many :products, through: :product_tax_rates, inverse_of: :tax_rates
  end
end
