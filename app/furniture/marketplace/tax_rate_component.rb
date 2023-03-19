class Marketplace
  class TaxRateComponent < ApplicationComponent
    attr_accessor :tax_rate

    def initialize(tax_rate:, data: {}, classes: "")
      super(data: data, classes: classes)

      self.tax_rate = tax_rate
    end
  end
end
