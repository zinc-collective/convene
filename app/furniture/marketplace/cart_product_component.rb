class Marketplace
  class CartProductComponent < ApplicationComponent
    attr_accessor :cart_product
    delegate :name, :description, :quantity, :location, to: :cart_product
    delegate :cart, :product, to: :cart_product

    def initialize(cart_product:, **)
      super(**)

      self.cart_product = cart_product
    end

    def dom_id
      super(cart_product)
    end
  end
end
