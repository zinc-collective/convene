class Marketplace
  class ProductComponentPreview < ViewComponent::Preview
    # @param name
    # @param price
    def card(name: "Grampy Tamps", price: 8.5)
      render(::Marketplace::ProductComponent.new(product: ::Marketplace::Product.new(name: name, price: price)))
    end
  end
end
