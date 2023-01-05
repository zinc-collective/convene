# frozen_string_literal: true

class Marketplace
  class MarketplacesController < FurnitureController
    def show
    end

    def edit
      marketplace
    end

    def update
      if marketplace.update(params[:marketplace].permit([:stripe_api_key]))
        redirect_to marketplace.location(:edit), notice: t('.success')
      else
        flash[:alert] = t('.failure')
        render :edit, status: :unprocessable_entity
      end
    end

    helper_method def marketplace
      authorize(Marketplace.find(params[:id]))
    end
  end
end
