class Marketplace
  class Cart
    class DeliveriesController < Controller
      def edit
        authorize(delivery)
        render turbo_stream: [turbo_stream.replace(dom_id(delivery), partial: "form")]
      end

      def update
        authorize(delivery)
        delivery.update(delivery_params)
        render turbo_stream: [turbo_stream.replace(dom_id(delivery), delivery)]
      end

      helper_method def delivery
        @delivery ||= policy_scope(marketplace.carts).find(params[:cart_id]).delivery
      end

      def delivery_params
        policy(Cart::Delivery).permit(params.require(:delivery))
      end
    end
  end
end
