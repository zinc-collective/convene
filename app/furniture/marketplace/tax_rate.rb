class Marketplace
  class TaxRate < Record
    self.table_name = "marketplace_tax_rates"
    belongs_to :marketplace
    self.location_parent = :marketplace
  end
end
