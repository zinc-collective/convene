class Marketplace
  class Cart
    class DeliveriesController < Controller
      def edit
        authorize(delivery)
        respond_to do |format|
          format.html
          format.turbo_stream do
            render turbo_stream: [turbo_stream.replace(dom_id(delivery), partial: "form")]
          end
        end
      end

      def update
        authorize(delivery)
        delivery.update(delivery_params)
        respond_to do |format|

          format.html do
            if delivery.persisted?
              redirect_to delivery.room.location
            else
              render :edit
            end
          end
          format.turbo_stream do
            render turbo_stream: [turbo_stream.replace(dom_id(delivery), delivery)]
          end
        end
      end

      helper_method def delivery
        @delivery ||= policy_scope(marketplace.carts).find(params[:cart_id]).becomes(Delivery)
      end

      def delivery_params
        policy(Cart::Delivery).permit(params.require(:delivery))
      end
    end
  end
end
