class Marketplace
  class CheckoutComponent < ApplicationComponent
    attr_accessor :checkout
    def initialize(*args, checkout:, **kwargs)
      self.checkout = checkout
      super(*args, **kwargs)
    end

    delegate :location, :cart, to: :checkout
    delegate :delivery, to: :cart
  end
end
