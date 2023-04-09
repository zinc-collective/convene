class Marketplace
  class ManagementMenuItemComponent < ApplicationComponent
    renders_one :icon, ->(variant: SvgComponent) do
      variant.new(classes: "w-6 h-6")
    end

    attr_accessor :location

    def initialize(location:, data: {}, classes: "")
      super(data: data, classes: classes)

      self.location = location
    end
  end
end
