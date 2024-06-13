class Marketplace
  class Cart::DeliveryAreaComponent < ApplicationComponent
    attr_accessor :cart
    delegate :delivery_area, to: :cart

    def initialize(*, cart:, **)
      self.cart = cart
      super(*, **)
    end

    def dom_id
      super(cart, :delivery_area)
    end

    def single_delivery_area?
      cart.marketplace.delivery_areas.unarchived.size == 1
    end

    def single_delivery_area_label
      cart.marketplace.delivery_areas.unarchived.first.label
    end
  end
end
