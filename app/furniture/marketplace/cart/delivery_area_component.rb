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

    def price
      helpers.humanized_money_with_symbol(delivery_area.price)
    end

    def fee_as_percentage
      "#{helpers.number_to_percentage(delivery_area.fee_as_percentage, precision: 0)} of subtotal"
    end

    def fee_description
      if delivery_area.charges_fee_as_percentage? && delivery_area.charges_fee_as_price?
        "#{price} plus #{fee_as_percentage}"
      elsif !delivery_area.charges_fee_as_percentage? && delivery_area.charges_fee_as_price?
        price
      elsif delivery_area.charges_fee_as_percentage? && !delivery_area.charges_fee_as_price?
        fee_as_percentage
      end
    end

    def single_delivery_area?
      cart.marketplace.delivery_areas.unarchived.size == 1
    end

    def single_delivery_area_label
      cart.marketplace.delivery_areas.unarchived.first.label
    end
  end
end
