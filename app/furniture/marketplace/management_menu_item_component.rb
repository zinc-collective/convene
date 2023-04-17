class Marketplace
  class ManagementMenuItemComponent < ApplicationComponent
    renders_one :icon, ->(icon: nil) do
      SvgComponent.new(icon: icon, classes: "w-6 h-6 flex-none")
    end

    renders_one :title, ->(content) do
      content
    end

    attr_accessor :location

    def initialize(location:, data: {}, classes: "")
      super(data: data, classes: classes)

      self.location = location
    end
  end
end
