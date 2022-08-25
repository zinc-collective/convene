class Marketplace
  class MarketplaceController < FurnitureController
    # @returns [Marketplace]
    helper_method def marketplace
      room.furniture_placements.find_by(furniture_kind: 'marketplace').furniture
    end
  end
end