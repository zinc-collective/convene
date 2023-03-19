class Marketplace
  class TaxRateComponentPreview < ViewComponent::Preview
    def card
      render(TaxRateComponent.new(tax_rate: TaxRate.all.sample))
    end
  end
end
