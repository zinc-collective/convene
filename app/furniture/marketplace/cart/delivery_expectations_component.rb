class Marketplace
  class Cart
    class DeliveryExpectationsComponent < ApplicationComponent
      attr_accessor :cart, :delivery_window, :order_by

      def initialize(cart:, order_by: cart.marketplace.order_by,
        delivery_window: cart.marketplace.delivery_window, **kwargs)
        super(**kwargs)

        self.cart = cart
        self.delivery_window = delivery_window
        self.order_by = order_by
      end
    end
  end
end
