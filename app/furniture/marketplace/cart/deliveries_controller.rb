class Marketplace
  class Cart
    class DeliveriesController < Controller
      def show
        authorize(delivery)
      end

      def edit
        authorize(delivery)
      end

      def update
        authorize(delivery)
        if delivery.update(delivery_params)
          redirect_to delivery.location
        else
          render :edit, status: :unprocessable_entity
        end
      end

      helper_method def delivery
        @delivery ||= cart.delivery
      end

      private

      def cart
        @cart ||= policy_scope(marketplace.carts).find(params[:cart_id])
      end

      def delivery_params
        policy(Cart::Delivery).permit(params.require(:delivery))
      end
    end
  end
end
