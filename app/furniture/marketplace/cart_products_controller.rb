class Marketplace
  class CartProductsController < FurnitureController
    def create
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
          render turbo_stream: turbo_stream.replace("cart-product-#{cart_product.product_id}", cart_product)
        end
      end
    end

    def update
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
          render turbo_stream: turbo_stream.replace("cart-product-#{cart_product.product_id}", cart_product)
        end
      end
    end

    def destroy
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
          render turbo_stream: turbo_stream.replace("cart-product-#{cart_product.product_id}", cart.cart_products.new(product: cart_product.product))
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

    def marketplace
      room.furniture_placements.find(params[:marketplace_id]).furniture
    end

    def cart_product_params
      params.require(:cart_product).permit(:quantity, :product_id)
    end
  end
end
