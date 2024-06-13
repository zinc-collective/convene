class Marketplace
  class MenuComponent < ApplicationComponent
    attr_accessor :marketplace, :cart

    def initialize(marketplace:, cart:, **)
      super(**)
      self.marketplace = marketplace
      self.cart = cart
    end
  end
end
