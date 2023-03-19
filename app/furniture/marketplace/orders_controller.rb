class Marketplace
  class OrdersController < Controller
    def show
      authorize(order)
    end

    def index
    end

    helper_method def orders
      policy_scope(marketplace.orders).order(created_at: :desc)
    end

    helper_method def order
      orders.find(params[:id])
    end
  end
end
