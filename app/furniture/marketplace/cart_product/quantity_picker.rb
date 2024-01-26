class Marketplace
  class CartProduct::QuantityPicker < Model
    attr_accessor :cart_product
    delegate :location, :quantity, to: :cart_product
  end
end
