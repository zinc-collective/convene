class Marketplace
  class TaxRate < Record
    self.table_name = "marketplace_tax_rates"
    location(parent: :marketplace)

    belongs_to :marketplace, inverse_of: :tax_rates
    has_one :space, through: :marketplace

    validates :tax_rate, numericality: {greater_than: 0, less_than_or_equal_to: 100}, presence: true
    validates :label, presence: true
    has_many :product_tax_rates, inverse_of: :tax_rate
    has_many :products, through: :product_tax_rates, inverse_of: :tax_rates
  end
end
