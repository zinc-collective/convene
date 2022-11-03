class Marketplace
  class ProductsController < FurnitureController
    def new; end

    def create
      product = marketplace.products.new(product_params)
      product.save!

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to [space, room] }
      end
    end

    helper_method def marketplace
      Marketplace.find(params[:marketplace_id])
    end

    def product_params
      policy(Product).permit(params.require(:marketplace_product))
    end
  end
end
