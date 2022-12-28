# frozen_string_literal: true

class Marketplace
  class ProductsController < FurnitureController
    def new
      authorize(marketplace.products.new)
    end

    def create
      authorize(product)
      product.save!

      respond_to do |format|
        format.html { redirect_to marketplace.location(child: :products) }
      end
    end

    def destroy
      respond_to do |format|
        if product.destroy
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
    end

    def update
      if product.update(product_params)
        redirect_to marketplace.location(child: :products)
      else
        render :edit
      end
    end

    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end

    helper_method def product
      @product ||= if params[:id]
        policy_scope(marketplace.products).find(params[:id])
      elsif params[:product]
        marketplace.products.new(product_params)
      end.tap { |product| authorize(product) }
    end

    def product_params
      policy(Product).permit(params.require(:product))
    end
  end
end
