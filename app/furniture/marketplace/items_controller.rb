# frozen_string_literal: true

class Marketplace
  class ItemsController < MarketplaceController
    def create
      item.save

      render turbo_stream: turbo_stream
        .append("#{dom_id(order)}-items", item)
    end

    private def item_params
      policy(items.new).permit(params.require(:marketplace_item)).merge(order: order, product: product)
    end

    helper_method def item
      @item ||= items.new(item_params)
    end

    helper_method def items
      @items ||= order.items
    end

    helper_method def order
      marketplace.orders.find(params[:order_id])
    end

    helper_method def product
      marketplace.products.find { |p| p.name == params[:marketplace_item][:product] }
    end
  end
end
