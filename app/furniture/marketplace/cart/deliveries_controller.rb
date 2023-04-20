class Marketplace
  class Cart
    class DeliveriesController < Controller
      def edit
        authorize(delivery)
        render turbo_stream: [turbo_stream.replace(delivery, partial: "form")]
      end

      def update
        authorize(delivery)
        delivery.update(delivery_params)
        if delivery.errors.present?
          render turbo_stream: [turbo_stream.replace(delivery, partial: "form")]
        else
          # Replace the entire cart footer so that the "Checkout" button updates as well
          render turbo_stream: [
            turbo_stream.replace("cart-footer-#{cart.id}",
              partial: "marketplace/carts/footer", locals: {cart: cart})
          ]
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
