class Marketplace
  class OrdersController < Controller
    expose :order, scope: -> { orders.includes(:events, ordered_products: [:product]) }, model: Order
    expose :orders, -> { OrderPolicy::Scope.new(shopper, marketplace.orders).resolve.order(created_at: :desc) }

    def show
      authorize(order)
    end

    def index
      skip_authorization
    end
  end
end
