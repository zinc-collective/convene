class Marketplace
  class OrderedProductsController < FurnitureController
    def create
      if ordered_product.save
        flash[:notice] =
          t('.success', product: ordered_product.product.name.pluralize(ordered_product.quantity),
                        quantity: ordered_product.quantity)
      else
        flash[:alert] =
          t('.failure', product: ordered_product.product.name.pluralize(ordered_product.quantity),
                        quantity: ordered_product.quantity)
      end

      redirect_to [marketplace.space, marketplace.room]
    end

    def update
      if ordered_product.update(ordered_product_params)
        flash[:notice] =
          t('.success', product: ordered_product.product.name.pluralize(ordered_product.quantity),
                        quantity: ordered_product.quantity)
      else
        flash[:alert] =
          t('.failure', product: ordered_product.product.name.pluralize(ordered_product.quantity),
                        quantity: ordered_product.quantity)
      end

      redirect_to [marketplace.space, marketplace.room]
    end

    def destroy
      if ordered_product.destroy
        flash[:notice] =
          t('.success', product: ordered_product.product.name.pluralize(ordered_product.quantity),
                        quantity: ordered_product.quantity)
      else
        flash[:alert] =
          t('.failure', product: ordered_product.product.name.pluralize(ordered_product.quantity),
                        quantity: ordered_product.quantity)
      end
      redirect_to [marketplace.space, marketplace.room]
    end

    def ordered_product
      @ordered_product ||= if params[:id]
        order.ordered_products.find(params[:id])
      elsif params[:ordered_product]
        order.ordered_products.new(ordered_product_params)
      end
    end

    def order
      marketplace.orders.find(params[:order_id])
    end

    def marketplace
      room.furniture_placements.find(params[:marketplace_id]).furniture
    end

    def ordered_product_params
      params.require(:ordered_product).permit(:quantity, :product_id)
    end
  end
end
