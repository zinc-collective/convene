class Marketplace
  class Cart::DeliveryAreasController < Controller
    expose :cart, scope: -> { carts }, model: Cart
    expose :carts, -> { policy_scope(marketplace.carts) }

    def show
      authorize(cart)
    end

    def edit
      authorize(cart)
    end

    def update
      authorize(cart)
      cart.update(cart_params)
      redirect_to marketplace.location
    end

    def cart_params
      params.require(:cart).permit(:delivery_area_id)
    end
  end
end
