class Marketplace
  class ProductsController < FurnitureController
    def create
      product = marketplace.products.new(product_params)
      product.save!

      render product
    end

    def marketplace
      Marketplace.find_by(room: room)
    end

    def product_params
      policy(Marketplace::Product).permit(params.require(:marketplace_product))
    end
  end
end
