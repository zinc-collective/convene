class Marketplace
  class TaxRate < Record
    self.table_name = "marketplace_tax_rates"
    self.location_parent = :marketplace

    belongs_to :marketplace, inverse_of: :tax_rates
    has_many :tax_rates, inverse_of: :tax_rates
  end
end
