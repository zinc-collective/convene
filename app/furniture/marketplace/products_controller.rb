# frozen_string_literal: true

class Marketplace
  class ProductsController < FurnitureController
    def new
    end

    def create
      product = marketplace.products.new(product_params)
      product.save!

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to marketplace.location(:products) }
      end
    end

    def destroy
      product = authorize(marketplace.products.find(params[:id]))

      respond_to do |format|
        if product.destroy
          format.turbo_stream { render turbo_stream: turbo_stream.remove(product) }
          format.html { redirect_to marketplace.location(:products) }
        else
          format.html { redirect_to product.location }
        end
      end
    end

    def index
    end

    helper_method def marketplace
      Marketplace.find(params[:marketplace_id])
    end

    def product_params
      policy(Product).permit(params.require(:product))
    end
  end
end
