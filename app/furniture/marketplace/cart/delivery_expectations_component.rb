class Marketplace
  class Cart
    class DeliveryExpectationsComponent < ApplicationComponent
      attr_accessor :cart

      def initialize(cart:, **kwargs)
        super(**kwargs)

        self.cart = cart
      end
    end
  end
end
