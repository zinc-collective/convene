class Marketplace
  class DeliveryAreasController < Controller
    def index
    end

    def new
      delivery_area
    end

    helper_method def delivery_area
      @delivery_area ||= authorize(delivery_areas.new)
    end

    helper_method def delivery_areas
      @delivery_areas ||= policy_scope(marketplace.delivery_areas)
    end
  end
end
