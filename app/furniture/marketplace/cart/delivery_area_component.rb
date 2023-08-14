class Marketplace
  class Cart::DeliveryAreaComponent < ApplicationComponent
    attr_accessor :cart
    delegate :delivery_area, to: :cart

    def initialize(*args, cart:, **kwargs)
      self.cart = cart
      super(*args, **kwargs)
    end

    def dom_id
      super(cart, :delivery_area)
    end
  end
end
