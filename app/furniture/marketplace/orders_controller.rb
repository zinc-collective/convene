class Marketplace
  class OrdersController < Controller
    def show
      authorize(order)
    end

    helper_method def order
      policy_scope(marketplace.orders).find(params[:id])
    end
  end
end
