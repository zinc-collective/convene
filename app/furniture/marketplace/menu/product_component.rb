class Marketplace
  class Menu::ProductComponent < ProductComponent
    attr_accessor :cart
    def initialize(product:, cart:, **)
      super(product:, **)
      self.cart = cart
    end
  end
end
