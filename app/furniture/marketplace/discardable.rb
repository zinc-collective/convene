class Marketplace
  module Discardable
    def self.included(model)
      model.include(Discard::Model)
    end

    def destroy_safely
      destroy if destroyable?
    end

    def with_orders?
      orders.present?
    end

    def discardable?
      persisted? && kept?
    end

    def destroyable?
      persisted? && discarded? && !with_orders?
    end
  end
end
