class Marketplace
  class TaxRateComponentPreview < ViewComponent::Preview
    # @param label
    # @param tax_rate
    def card(label: "Sales Tax", tax_rate: 8.5)
      render(::Marketplace::TaxRateComponent.new(tax_rate: ::Marketplace::TaxRate.new(label: label, tax_rate: tax_rate)))
    end
  end
end
