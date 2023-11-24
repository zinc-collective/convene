# frozen_string_literal: true

class Marketplace
  class FlyersController < Controller
    layout "minimal"
    expose :flyer, -> { marketplace.flyer }

    def show
      authorize(flyer)
    end
  end
end
