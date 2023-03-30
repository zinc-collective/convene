class Marketplace
  class CartsController < Controller
    def create
      authorize(cart)
      cart.save
      redirect_to cart.room.location
    end

    def update
      authorize(cart)
      cart.update(cart_params)
      respond_to do |format|
        format.html do
          redirect_to cart.room.location
        end
        format.turbo_stream do
          render turbo_stream: [turbo_stream.replace(dom_id(cart), cart)]
        end
      end
    end

    def cart
      @cart ||= if params[:id]
        policy_scope(marketplace.carts).find(params[:id])
      else
        policy_scope(marketplace.carts).new(cart_params)
      end
    end

    def cart_params
      policy(Cart).permit(params.require(:cart))
    end
  end
end
