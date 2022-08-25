# frozen_string_literal: true

class Marketplace
  class CheckoutsController < MarketplaceController
    def show
      render turbo_stream: turbo_stream.replace(dom_id(marketplace), checkout)
    end

    helper_method def checkout
      order.checkout
    end

    helper_method def order
      marketplace.orders.find(params[:order_id])
    end
  end
end
