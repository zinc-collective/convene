class Marketplace
  class CartProduct::NotesController < Controller
    expose :cart, scope: -> { policy_scope(marketplace.carts) }, model: Cart
    expose :cart_product, scope: -> { policy_scope(cart.cart_products) }, model: CartProduct

    def new
      authorize(cart_product, :update?)
    end

    def show
      authorize(cart_product)
    end

    def edit
      authorize(cart_product)
    end

    def update
      authorize(cart_product)
      cart_product.update(cart_product_params)

      if cart_product.errors.present?
        render :new, status: :unprocessable_entity
      else
        redirect_to cart_product.location(child: :note)
      end
    end

    def cart_product_params
      params.require(:cart_product).permit(:note)
    end
  end
end
