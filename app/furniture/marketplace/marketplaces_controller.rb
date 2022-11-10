# frozen_string_literal: true

class Marketplace
  class MarketplacesController < FurnitureController
    def show; end

    helper_method def marketplace
      Marketplace.find(params[:id])
    end
  end
end
