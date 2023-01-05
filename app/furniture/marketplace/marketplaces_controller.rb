# frozen_string_literal: true

class Marketplace
  class MarketplacesController < FurnitureController
    def show
    end

    def edit
      marketplace
    end

    def update
      marketplace.update(params[:marketplace].permit([:stripe_api_key]))
    end

    helper_method def marketplace
      authorize(Marketplace.find(params[:id]))
    end
  end
end
