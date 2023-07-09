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

      respond_to do |format|
        format.html do
          if product.persisted?
            redirect_to marketplace.location(child: :products), notice: t(".success", name: product.name)
          else
            render :new, status: :unprocessable_entity
          end
        end
      end
    end

    def destroy
      respond_to do |format|
        if authorize(product).destroy
          format.turbo_stream { render turbo_stream: turbo_stream.remove(product) }
          format.html { redirect_to marketplace.location(child: :products) }
        else
          format.html { redirect_to product.location }
        end
      end
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
        render :edit
      end
    end

    def product_params
      policy(Product).permit(params.require(:product))
    end
  end
end
