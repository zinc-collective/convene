class Marketplace
  class CartProductsController < FurnitureController
    def create
      authorize(cart_product)
      cart_product.save

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
            turbo_stream.replace("cart-product-#{cart_product.product_id}", cart_product),
            turbo_stream.replace("cart-footer-#{cart.id}",
              partial: "marketplace/carts/footer", locals: {cart: cart}),
            ]
        end
      end
    end

    def update
      authorize(cart_product)
      cart_product.update(cart_product_params)
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
            turbo_stream.replace("cart-product-#{cart_product.product_id}", cart_product),
            turbo_stream.replace("cart-footer-#{cart.id}",
              partial: "marketplace/carts/footer", locals: {cart: cart}),
            ]
        end
      end
    end

    def destroy
      authorize(cart_product)
      cart_product.destroy
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
            turbo_stream.replace("cart-product-#{cart_product.product_id}", cart.cart_products.new(product: cart_product.product)),
            turbo_stream.replace("cart-footer-#{cart.id}",
              partial: "marketplace/carts/footer", locals: {cart: cart})
          ]
        end
      end
    end

    def cart_product
      @cart_product ||= if params[:id]
        cart.cart_products.find(params[:id])
      elsif params[:cart_product]
        cart.cart_products.new(cart_product_params)
      end
    end

    def cart
      marketplace.carts.find(params[:cart_id])
    end

    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end

    def cart_product_params
      params.require(:cart_product).permit(:quantity, :product_id)
    end
  end
end
