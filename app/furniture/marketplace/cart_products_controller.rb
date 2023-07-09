class Marketplace
  class CartProductsController < Controller
    expose :cart, scope: -> { policy_scope(marketplace.carts) }, model: Cart
    expose :cart_product, scope: -> { policy_scope(cart.cart_products) }, model: CartProduct

    def create
      authorize(cart_product).save

      respond_to do |format|
        format.html do
          if cart_product.errors.empty?
            flash[:notice] = t(".success",
              product: cart_product.product.name.pluralize(cart_product.quantity),
              quantity: cart_product.quantity)
          else
            flash[:alert] = t(".failure",
              product: cart_product.product.name.pluralize(cart_product.quantity),
              quantity: cart_product.quantity)
          end

          redirect_to [marketplace.space, marketplace.room]
        end

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(cart_product_component.dom_id, cart_product_component),
            turbo_stream.replace("cart-footer-#{cart.id}",
              partial: "marketplace/carts/footer", locals: {cart: cart}),
            turbo_stream.replace("cart-total-#{cart.id}", partial: "marketplace/carts/total", locals: {cart: cart})
          ]
        end
      end
    end

    def update
      authorize(cart_product).update(cart_product_params)
      respond_to do |format|
        format.html do
          if cart_product.errors.empty?
            flash[:notice] =
              t(".success", product: cart_product.product.name.pluralize(cart_product.quantity),
                quantity: cart_product.quantity)
          else
            flash[:alert] =
              t(".failure", product: cart_product.product.name.pluralize(cart_product.quantity),
                quantity: cart_product.quantity)
          end

          redirect_to [marketplace.space, marketplace.room]
        end
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(cart_product_component.dom_id, cart_product_component),
            turbo_stream.replace("cart-footer-#{cart.id}",
              partial: "marketplace/carts/footer", locals: {cart: cart}),
            turbo_stream.replace("cart-total-#{cart.id}", partial: "marketplace/carts/total", locals: {cart: cart})
          ]
        end
      end
    end

    def destroy
      authorize(cart_product).destroy
      respond_to do |format|
        format.html do
          if cart_product.destroyed?
            flash[:notice] =
              t(".success", product: cart_product.product.name.pluralize(cart_product.quantity),
                quantity: cart_product.quantity)
          else
            flash[:alert] =
              t(".failure", product: cart_product.product.name.pluralize(cart_product.quantity),
                quantity: cart_product.quantity)
          end
          redirect_to [marketplace.space, marketplace.room]
        end

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(cart_product_component.dom_id, cart_product_component),
            turbo_stream.replace("cart-footer-#{cart.id}",
              partial: "marketplace/carts/footer", locals: {cart: cart}),
            turbo_stream.replace("cart-total-#{cart.id}", partial: "marketplace/carts/total", locals: {cart: cart})
          ]
        end
      end
    end

    def cart_product_component
      @cart_product_component ||= CartProductComponent.new(cart_product: cart_product)
    end

    def cart_product_params
      params.require(:cart_product).permit(:quantity, :product_id)
    end
  end
end
