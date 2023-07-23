# frozen_string_literal: true

class Marketplace
  class MarketplacesController < Controller
    def show
      authorize(marketplace)
    end

    def edit
      authorize(marketplace)
    end
  end
end
