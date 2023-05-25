class Marketplace
  class CartProductComponent < ApplicationComponent
    attr_accessor :cart_product
    delegate :name, :description, :location, to: :cart_product
    delegate :cart, :product, to: :cart_product

    def initialize(cart_product:, **kwargs)
      super(**kwargs)

      self.cart_product = cart_product
    end

    def quantity
      cart_product.destroyed? ? 0 : cart_product.quantity
    end

    def add_quantity
      quantity + 1
    end

    def add_method
      (add_quantity == 1) ? :post : :put
    end

    def add_href
      cart_product.location(query_params: {cart_product: {quantity: add_quantity, product_id: product.id}})
    end

    def remove_quantity
      [quantity - 1, 0].max
    end

    def remove_method
      remove_quantity.zero? ? :delete : :put
    end

    def remove_href
      cart_product.location(query_params: {cart_product: {quantity: remove_quantity, product_id: product.id}})
    end

    def dom_id
      super(product).gsub("product", "cart_product")
    end
  end
end
