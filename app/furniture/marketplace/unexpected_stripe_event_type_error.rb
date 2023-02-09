class Marketplace
  class UnexpectedStripeEventTypeError < StandardError
    def initialize(type)
      super("We aren't sure how to handle Stripe events of #{type}")
    end
  end
end
