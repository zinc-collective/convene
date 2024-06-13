class Marketplace
  class Cart
    class DeliveryExpectationsComponent < ApplicationComponent
      attr_accessor :cart, :delivery_window, :order_by

      def initialize(cart:, order_by: cart.delivery_area&.order_by,
        delivery_window: cart.delivery_area&.delivery_window, **)
        super(**)

        self.cart = cart
        self.delivery_window = delivery_window
        self.order_by = order_by
      end

      def render?
        cart.delivery_area.present?
      end

      def render_delivery_window
        render(Marketplace::Cart::DeliveryWindowComponent.new(window: delivery_window))
      end
    end
  end
end
