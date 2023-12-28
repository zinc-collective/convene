class Marketplace
  class ShopperFrameComponent < Component
    attr_accessor :marketplace

    def initialize(marketplace:, **kwargs)
      super(**kwargs)

      self.marketplace = marketplace
    end
  end
end
