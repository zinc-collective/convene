class Marketplace
  class ProductComponentPreview < ViewComponent::Preview
    # @param name
    # @param price
    def card(name: "Fancy Pants", price: 8.5)
      render(ProductComponent.new(product: Product.new(name: name, price: price)))
    end
  end
end
