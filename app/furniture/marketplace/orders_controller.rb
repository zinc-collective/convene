class Marketplace
  class OrdersController < Controller
    expose :order, scope: -> { orders }, model: Order
    expose :orders, -> { policy_scope(marketplace.orders).order(created_at: :desc) }

    def show
      authorize(order)
    end

    def index
      skip_authorization
    end
  end
end
