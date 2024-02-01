class Marketplace
  class Product::TitleComponent < Component
    attr_accessor :product
    delegate :servings, :name, to: :product

    def initialize(product:)
      self.product = product
    end
  end
end
