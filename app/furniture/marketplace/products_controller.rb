class Marketplace
  class ProductsController < FurnitureController
    def create
      product = marketplace.products.new(product_params)
      product.save!
    end

    def marketplace
      Marketplace.find_by(room: room)
    end

    def product_params
      policy(Marketplace::Product).permit(params.require(:product))
    end
  end
end
