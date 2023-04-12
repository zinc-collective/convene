class Marketplace
  class ManagementComponent < ApplicationComponent
    attr_accessor :marketplace

    def initialize(marketplace:, **kwargs)
      super(**kwargs)

      self.marketplace = marketplace
    end
  end
end
