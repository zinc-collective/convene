class Marketplace
  class ManagementComponent < ApplicationComponent
    attr_accessor :marketplace

    def initialize(marketplace:, data: {}, classes: "")
      super(data: data, classes: classes)

      self.marketplace = marketplace
    end
  end
end
