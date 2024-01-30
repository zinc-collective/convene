class Marketplace
  class CartProductsController < Controller
    expose :cart, scope: -> { policy_scope(marketplace.carts) }, model: Cart
    expose :cart_product, scope: -> { policy_scope(cart.cart_products) }, model: CartProduct

    def create
      authorize(cart_product).save

      if cart_product.errors.empty?
        flash[:notice] = t(".success",
          product: cart_product.product.name.pluralize(cart_product.quantity),
          quantity: cart_product.quantity)
      else
        flash[:alert] = t(".failure",
          product: cart_product.product.name.pluralize(cart_product.quantity),
          quantity: cart_product.quantity)
      end

      redirect_to marketplace.location
    end

    def update
      authorize(cart_product).update(cart_product_params)
      if cart_product.errors.empty?
        flash[:notice] =
          t(".success", product: cart_product.product.name.pluralize(cart_product.quantity),
            quantity: cart_product.quantity)
      else
        flash[:alert] =
          t(".failure", product: cart_product.product.name.pluralize(cart_product.quantity),
            quantity: cart_product.quantity)
      end

      redirect_to marketplace.location
    end

    def destroy
      authorize(cart_product).destroy

      if cart_product.destroyed?
        flash[:notice] =
          t(".success", product: cart_product.product.name.pluralize(cart_product.quantity),
            quantity: cart_product.quantity)
      else
        flash[:alert] =
          t(".failure", product: cart_product.product.name.pluralize(cart_product.quantity),
            quantity: cart_product.quantity)
      end
      redirect_to marketplace.location
    end

    def cart_product_component
      @cart_product_component ||= CartProductComponent.new(cart_product: cart_product)
    end

    def cart_product_params
      params.require(:cart_product).permit(:quantity, :product_id)
    end
  end
end
