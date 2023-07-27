class Marketplace
  class Order::EventsController < Controller
    expose :order, scope: -> { OrderPolicy::Scope.new(shopper, marketplace.orders).resolve }, model: Order
    helper_method def events
      policy_scope(order.events)
    end

    def index
      skip_authorization
    end
  end
end
