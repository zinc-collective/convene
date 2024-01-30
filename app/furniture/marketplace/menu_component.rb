class Marketplace
  class MenuComponent < ApplicationComponent
    attr_accessor :marketplace, :cart

    def initialize(marketplace:, cart:, **kwargs)
      super(**kwargs)
      self.marketplace = marketplace
      self.cart = cart
    end
  end
end
