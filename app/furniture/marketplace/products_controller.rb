# frozen_string_literal: true

class Marketplace
  class ProductsController < Controller
    expose :product, scope: -> { products }, model: Product
    expose :products, -> { policy_scope(marketplace.products) }

    def new
      authorize(product)
    end

    def create
      authorize(product).save

      if product.persisted?
        redirect_to marketplace.location(child: :products), notice: t(".success", name: product.name)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      authorize(product)

      if product.discarded?
        product.destroy if product.destroyable?
      else
        product.discard
      end

      redirect_to marketplace.location(child: :products)
    end

    def index
      skip_authorization
    end

    def edit
      authorize(product)
    end

    def update
      if authorize(product).update(product_params)
        redirect_to marketplace.location(child: :products)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def product_params
      policy(Product).permit(params.require(:product))
    end
  end
end
