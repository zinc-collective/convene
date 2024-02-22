# frozen_string_literal: true

class Marketplace
  class ProductsController < Controller
    expose :product, scope: -> { products }, model: Product
    expose :products, -> { policy_scope(marketplace.products.with_all_rich_text) }

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

      product.archive if !product.destroy_safely

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
