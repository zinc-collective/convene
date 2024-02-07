class Marketplace
  class Menu::ProductComponent < ProductComponent
    attr_accessor :cart
    def initialize(product:, cart:, **kwargs)
      super(product:, **kwargs)
      self.cart = cart
    end
  end
end
