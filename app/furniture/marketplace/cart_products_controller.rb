class Marketplace
  class CartProductsController < FurnitureController
    def create
      if cart_product.save
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

    def update
      if cart_product.update(cart_product_params)
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

    def destroy
      if cart_product.destroy
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
