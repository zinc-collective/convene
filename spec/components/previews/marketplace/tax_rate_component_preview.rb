class Marketplace
  class TaxRateComponentPreview < ViewComponent::Preview
    # @param label
    # @param tax_rate
    def card(label: "Sales Tax", tax_rate: 8.5)
      render(TaxRateComponent.new(tax_rate: TaxRate.new(label: label, tax_rate: tax_rate)))
    end
  end
end
